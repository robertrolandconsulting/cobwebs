      ********************************************
      * Add a user
      *
      * ADDUSER
      *
      *
      * Copyright (c) 2024 Robert Roland
      ********************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.   ADDUSER.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  DB-CONNECT-PARAMS.
           05  DB-SERVER           PIC X(50).
           05  DB-PORT             PIC X(5).
           05  DB-DATABASE         PIC X(50).
           05  DB-UID              PIC X(50).
           05  DB-PWD              PIC X(50).

       01  D-USER-REC.
           05  D-USER-ID           PIC X(36).
           05  D-USER-NAME         PIC X(50).
           05  D-USER-EMAIL        PIC X(50).
           05  D-USER-PW_HASH      PIC X(76).

       EXEC SQL
           BEGIN DECLARE SECTION
       END-EXEC.
       01  HOSTVARS.
           05 BUFFER               PIC X(1024).

       01  USER-REC-VARS.
           05  USER-ID             PIC X(36).
           05  USER-NAME           PIC X(50).
           05  USER-EMAIL          PIC X(50).
           05  USER-PW_HASH        PIC X(76).

       01  WS-SHA3-512-OUTPUT                 PIC X(64).

       EXEC SQL
           END DECLARE SECTION
       END-EXEC.

       EXEC SQL
           INCLUDE SQLCA
       END-EXEC.

       01  WS-INPUT                           PIC X(200).
       01  WS-INPUT-BYTE-LEN                  BINARY-DOUBLE UNSIGNED.

       PROCEDURE DIVISION.

       MAIN-RTN.
           DISPLAY "ADDUSER STARTED".

      *    CONNECT TO THE DATABASE
           ACCEPT DB-SERVER FROM ENVIRONMENT 'DB_SERVER'.
           ACCEPT DB-PORT FROM ENVIRONMENT 'DB_PORT'.
           ACCEPT DB-DATABASE FROM ENVIRONMENT 'DB_DATABASE'.
           ACCEPT DB-UID FROM ENVIRONMENT 'DB_UID'.
           ACCEPT DB-PWD FROM ENVIRONMENT 'DB_PWD'.

           STRING 'DRIVER={PostgreSQL};'
                  'SERVER=' FUNCTION TRIM(DB-SERVER) ';'
                  'PORT=' FUNCTION TRIM(DB-PORT) ';'
                  'DATABASE=' FUNCTION TRIM(DB-DATABASE) ';'
                  'UID=' FUNCTION TRIM(DB-UID) ';'
                  'PWD=' FUNCTION TRIM(DB-PWD) ';'
           INTO BUFFER.

           EXEC SQL
               CONNECT TO :BUFFER
           END-EXEC.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN STOP RUN.

           DISPLAY 'Enter user name: '.
           ACCEPT USER-NAME.

           DISPLAY 'Enter email: '.
           ACCEPT USER-EMAIL.

           DISPLAY 'Enter password: '.
           ACCEPT WS-INPUT.
           MOVE FUNCTION stored-char-length(WS-INPUT) 
               TO WS-INPUT-BYTE-LEN.

           CALL "SHA3-512" USING WS-INPUT
                                 WS-INPUT-BYTE-LEN
                                 WS-SHA3-512-OUTPUT
           END-CALL.

           MOVE FUNCTION HEX-TO-CHAR(WS-SHA3-512-OUTPUT) 
               TO USER-PW_HASH.

           EXEC SQL
               INSERT INTO users (
                   name,
                   email,
                   password_hash
               ) VALUES (
                   :USER-NAME,
                   :USER-EMAIL,
                   :USER-PW_HASH
               )
           END-EXEC.

      *    COMMIT
           EXEC SQL
               COMMIT WORK
           END-EXEC.

      *    DISCONNECT
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.

      *    END
           DISPLAY "ADDUSER FINISHED".
           STOP RUN.

       ERROR-RTN.
           DISPLAY "*** SQL ERROR ***".
           DISPLAY "SQLCODE: " SQLCODE " " NO ADVANCING.
           EVALUATE SQLCODE
               WHEN +10
                   DISPLAY "Record not found"
               WHEN -01
                   DISPLAY "Connection failed"
               WHEN -20
                   DISPLAY "Internal error"
               WHEN -30
                   DISPLAY "PostgreSQL error"
                   DISPLAY "ERRCODE: " SQLSTATE
                   DISPLAY SQLERRMC
                  *> TO RESTART TRANSACTION, DO ROLLBACK.
                   EXEC SQL
                       ROLLBACK
                   END-EXEC
               WHEN OTHER
                   DISPLAY "Undefined error"
                   DISPLAY "ERRCODE: " SQLSTATE
                   DISPLAY SQLERRMC
           END-EVALUATE.

       END-PROGRAM.
