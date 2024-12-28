      ********************************************
      * Route HTTP requests
      *
      * router
      *
      * Copyright (c) 2024 Robert Roland
      ********************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.   router.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  HOSTVARS.
           05 BUFFER               PIC X(1024).

       01  REQUEST-VARS.
           05 NUM-ROUTES           PIC S9(04) COMP.
           05 ROUTE-TABLE OCCURS 10 TIMES INDEXED BY ROUTE-IDX.
      * GET / POST / PUT / PATCH / DELETE / HEAD
               10 ROUTE-METHOD        PIC X(6).
               10 ROUTE-PATH          PIC X(1024).
               10 ROUTE-DESTINATION   PIC X(100).

           05 REQUEST-URI             PIC X(1024).
           05 REQUEST-METHOD          PIC X(6).

       01  request-uri-split.
           05 request-uri-pieces OCCURS 10 TIMES.
              10 request-uri-piece PIC X(80) VALUE SPACES.
               77  request-uri-count PIC S9(04).

       01  SPLIT-QUERY.
           05 SPLIT-PATH-PIECES OCCURS 10 TIMES.
              10 SPLIT-PATH-PIECE PIC X(80) VALUE SPACES.
           05 SPLIT-PATTERN-PIECES OCCURS 10 TIMES.
              10 SPLIT-PATTERN-PIECE PIC X(80) VALUE SPACES.

       77  REQ-URI-PART    PIC X(100).
       77  ROUTE-URI-PART  PIC X(100).

       77  COUNTER PIC S9(04) COMP.
       77  POS     PIC S9(04).

       77  TOTAL-PIECES PIC S9(04).

       LINKAGE SECTION.

       PROCEDURE DIVISION.

       ROUTE-TEST.
           DISPLAY "Testing routing".

           MOVE 'PUT' TO ROUTE-METHOD(1).
           MOVE '/api/foo' TO ROUTE-PATH(1).

           MOVE 'GET' TO ROUTE-METHOD(2).
           MOVE '/api/foo/:bar' TO ROUTE-PATH(2).

           MOVE 2 TO NUM-ROUTES.

           MOVE 'GET' TO REQUEST-METHOD.
           MOVE '/api/foo/1234' TO REQUEST-URI.

           DISPLAY "There are " NUM-ROUTES " routes defined".

           PERFORM MATCH-ROUTE

           DISPLAY "Done".
           GOBACK.

       MATCH-ROUTE.

      * General pattern here:
      *    UNSTRING the path from the CGI request
      *    Loop over the ROUTE-TABLE
      *    IF ROUTE-METHOD matches, UNSTRING the ROUTE-PATH
      *    Loop over the parts AND check FOR matches
      *    ANY :variable name gets stored as a VALUE IN the
      *      request parameters

           DISPLAY "Route scan".

           MOVE 0 TO TOTAL-PIECES
           MOVE 1 TO COUNTER
           MOVE 1 TO POS

      * Split UP the user request STRING INTO an array
           CALL 'split-request-uri' 
           USING REQUEST-URI request-uri-split

           DISPLAY "Request-URI " REQUEST-URI
           DISPLAY "Request pieces " TOTAL-PIECES
           DISPLAY "Piece 1 " SPLIT-PATH-PIECES(1)

           PERFORM VARYING ROUTE-IDX FROM 1 BY 1
               UNTIL ROUTE-IDX > NUM-ROUTES

               IF REQUEST-METHOD = ROUTE-METHOD(ROUTE-IDX)
                   DISPLAY "Matched method at " ROUTE-IDX

                   MOVE 1 TO COUNTER
                   MOVE 1 TO POS

                   PERFORM VARYING COUNTER FROM 2 BY 1
                       UNTIL COUNTER > 10

                       SUBTRACT 1 FROM COUNTER GIVING POS

                       UNSTRING REQUEST-URI DELIMITED BY ALL '/'
                           INTO SPLIT-PATH-PIECES(POS)
                       END-UNSTRING

                       DISPLAY SPLIT-PATH-PIECES(COUNTER)
                   END-PERFORM
               END-IF
           END-PERFORM.

           GOBACK.
       END PROGRAM router.

       IDENTIFICATION DIVISION.

       PROGRAM-ID. split-request-uri.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  COUNTER PIC S9(04) COMP.
       77  POS     PIC S9(04).

       LINKAGE SECTION.

       01  uri-values.
           05  uri PIC X(1024).

       01  split-uri-out.
           05 split-uri-pieces OCCURS 10 TIMES.
              10 split-uri-piece PIC X(80) VALUE SPACES.

           77  split-uri-count PIC S9(04).

       PROCEDURE DIVISION USING uri-values split-uri-out.

       PERFORM VARYING COUNTER FROM 2 BY 1 UNTIL COUNTER > 10
           SUBTRACT 1 FROM COUNTER GIVING POS

           UNSTRING uri DELIMITED BY ALL '/'
               INTO split-uri-pieces(POS)
               TALLYING IN split-uri-count
           END-UNSTRING
       END-PERFORM.

       GOBACK.
           
       END PROGRAM split-request-uri.
