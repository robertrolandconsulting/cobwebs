      ********************************************
      * Fetch a list of books
      *
      * LISTBOOKS
      *
      *
      * Copyright (c) 2024 Robert Roland
      ********************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.   LISTBOOKS.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  D-BOOK-REC.
           05  D-BOOK-ID           PIC X(36).
           05  D-BOOK-NAME         PIC X(50).
           05  D-BOOK-AUTHOR       PIC X(50).
           05  D-BOOK-YEAR         PIC 9(4).
           05  D-BOOK-ISBN10       PIC X(10).
           05  D-BOOK-SYNOPSIS     PIC X(1024).

       EXEC SQL
           BEGIN DECLARE SECTION
       END-EXEC.
       01  HOSTVARS.
           05 BUFFER               PIC X(1024).

       01  BOOK-REC-VARS.
           05  BOOK-ID             PIC X(36).
           05  BOOK-NAME           PIC X(50).
           05  BOOK-AUTHOR         PIC X(50).
           05  BOOK-YEAR           PIC 9(4).
           05  BOOK-ISBN10         PIC X(10).
           05  BOOK-SYNOPSIS       PIC X(1024).

       01  BOOK-CNT                PIC 9(8).
       EXEC SQL
           END DECLARE SECTION
       END-EXEC.

       EXEC SQL
           INCLUDE SQLCA
       END-EXEC.

       PROCEDURE DIVISION.

       MAIN-RTN.
           DISPLAY "LISTBOOKS STARTED".

      *    CONNECT TO THE DATABASE
           STRING 'DRIVER={PostgreSQL};'
                  'SERVER=localhost;'
                  'PORT=5432;'
                  'DATABASE=books;'
                  'UID=books;'
                  'PWD=b00ks!;'
           INTO BUFFER.

           EXEC SQL
               CONNECT TO :BUFFER
           END-EXEC.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN STOP RUN.

      *    SELECT COUNT(*) INTO HOST-VARIABLE
           EXEC SQL
               SELECT COUNT(*) INTO :BOOK-CNT FROM BOOKS
           END-EXEC.
           DISPLAY "TOTAL BOOKS: " BOOK-CNT.

      *    DECLARE CURSOR
           EXEC SQL
               DECLARE C1 CURSOR FOR
               SELECT id, name, author, year,
                      isbn10, synopsis
                      FROM BOOKS
                      ORDER BY id
           END-EXEC.
           EXEC SQL
               OPEN C1
           END-EXEC.

      *    FETCH FROM THE CURSOR
           DISPLAY "------------".
           EXEC SQL
               FETCH C1 INTO :BOOK-ID, :BOOK-NAME, :BOOK-AUTHOR,
                             :BOOK-YEAR, :BOOK-ISBN10, :BOOK-SYNOPSIS
           END-EXEC.
           PERFORM UNTIL SQLCODE NOT = ZERO
               MOVE BOOK-ID TO D-BOOK-ID
               MOVE BOOK-NAME TO D-BOOK-NAME
               MOVE BOOK-AUTHOR TO D-BOOK-AUTHOR
               MOVE BOOK-YEAR TO D-BOOK-YEAR
               MOVE BOOK-ISBN10 TO D-BOOK-ISBN10
               MOVE BOOK-SYNOPSIS TO D-BOOK-SYNOPSIS
               DISPLAY D-BOOK-REC
               EXEC SQL
                   FETCH C1 INTO :BOOK-ID, :BOOK-NAME, :BOOK-AUTHOR,
                                 :BOOK-YEAR, :BOOK-ISBN10, 
                                 :BOOK-SYNOPSIS
               END-EXEC
           END-PERFORM.

      *    CLOSE CURSOR
           EXEC SQL
               CLOSE C1
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
           DISPLAY "LISTBOOKS FINISHED".
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
