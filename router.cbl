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
           05  request-uri-count PIC S9(04).

       01  route-uri-split.
           05 route-uri-pieces OCCURS 10 TIMES.
               10 route-uri-piece PIC X(80) VALUE SPACES.
           05  route-uri-count PIC S9(04).
       
       01  matched  pic x(1).
       01  piece-idx PIC S9(04).

       LINKAGE SECTION.

       PROCEDURE DIVISION.

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

      * Split UP the user request STRING INTO an array
           CALL 'split-request-uri' 
           USING REQUEST-URI REQUEST-URI-SPLIT
           
           MOVE 'n' TO matched

           PERFORM VARYING ROUTE-IDX FROM 1 BY 1
               UNTIL ROUTE-IDX > NUM-ROUTES

               IF REQUEST-METHOD = ROUTE-METHOD(ROUTE-IDX)
                   DISPLAY "Matched method at " ROUTE-IDX

                   CALL 'split-request-uri' 
                   USING ROUTE-PATH(ROUTE-IDX) ROUTE-URI-SPLIT
                   
                   IF REQUEST-URI-COUNT = ROUTE-URI-COUNT
                       DISPLAY "possible match on count"

                       MOVE 1 TO piece-idx

                       DISPLAY 'uri-count ' route-uri-count

                       PERFORM VARYING piece-idx 
                           FROM 1 BY 1
                           UNTIL piece-idx > route-uri-count

                           DISPLAY 'piece-idx ' piece-idx

                       END-PERFORM

                       MOVE 'y' to matched
                   END-IF
               END-IF
           END-PERFORM.

           GOBACK.
       END PROGRAM router.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. split-request-uri.

       DATA DIVISION.

       LOCAL-STORAGE SECTION.

       01  split-uri.
           05 split-uri-pieces OCCURS 10 TIMES.
              10 split-uri-piece PIC X(80) VALUE SPACES.

           05  split-uri-count PIC S9(04) VALUE 0.

       77  COUNTER PIC S9(04) COMP.
       77  PTR     PIC S9(04) VALUE 1.

       LINKAGE SECTION.

       01  uri-values.
           05  uri PIC X(1024) VALUE SPACES.

       01  split-uri-out.
           05 split-uri-pieces-out OCCURS 10 TIMES.
              10 split-uri-piece-out PIC X(80) VALUE SPACES.
           05  split-uri-count-out PIC S9(04) VALUE 0.

       PROCEDURE DIVISION USING URI-VALUES SPLIT-URI-OUT.
              
       MOVE 1 TO COUNTER.
       MOVE 1 TO PTR.

       MOVE 0 TO split-uri-count.

       PERFORM VARYING COUNTER FROM 1 BY 1 UNTIL COUNTER > 10
           UNSTRING URI DELIMITED BY ALL '/'          
               INTO SPLIT-URI-PIECES(COUNTER)
               WITH POINTER PTR               
               TALLYING IN split-uri-count
           END-UNSTRING
       END-PERFORM.

       MOVE SPLIT-URI TO SPLIT-URI-OUT.
       
       DISPLAY 'Done = ' split-uri-count.
       DISPLAY 'Out  = ' split-uri-count-out.
       GOBACK.
           
       END PROGRAM split-request-uri.
