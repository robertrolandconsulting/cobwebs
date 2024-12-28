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

       01  hostvars.
           05 buffer               PIC X(1024).

       01  request-vars.
           05 num-routes           PIC S9(04) COMP.
           05 route-table OCCURS 10 TIMES INDEXED BY route-idx.
      * GET / POST / PUT / PATCH / DELETE / HEAD
               10 route-method        PIC X(6).
               10 route-path          PIC X(1024).
               10 route-destination   PIC X(100).

           05 request-uri             PIC X(1024).
           05 request-method          PIC X(6).

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

           MOVE 'PUT' TO route-method(1).
           MOVE '/api/foo' TO route-path(1).

           MOVE 'GET' TO route-method(2).
           MOVE '/api/foo/:bar' TO route-path(2).

           MOVE 2 TO num-routes.

           MOVE 'GET' TO request-method.
           MOVE '/api/foo/1234' TO request-uri.

           DISPLAY "There are " num-routes " routes defined".

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
           USING request-uri request-uri-split
           
           MOVE 'n' TO matched

           PERFORM VARYING route-idx FROM 1 BY 1
               UNTIL route-idx > num-routes

               IF request-method = route-method(route-idx)
                   DISPLAY "Matched method at " route-idx

                   CALL 'split-request-uri' 
                   USING route-path(route-idx) route-uri-split
                   
                   IF request-uri-count = route-uri-count
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

       77  counter PIC S9(04) COMP.
       77  ptr     PIC S9(04) VALUE 1.

       LINKAGE SECTION.

       01  uri-values.
           05  uri PIC X(1024) VALUE SPACES.

       01  split-uri-out.
           05 split-uri-pieces-out OCCURS 10 TIMES.
              10 split-uri-piece-out PIC X(80) VALUE SPACES.
           05  split-uri-count-out PIC S9(04) VALUE 0.

       PROCEDURE DIVISION USING URI-VALUES SPLIT-URI-OUT.
              
       MOVE 1 TO counter.
       MOVE 1 TO ptr.

       MOVE 0 TO split-uri-count.

       PERFORM VARYING counter FROM 1 BY 1 UNTIL counter > 10
           UNSTRING uri DELIMITED BY ALL '/'          
               INTO split-uri-pieces(counter)
               WITH POINTER ptr               
               TALLYING IN split-uri-count
           END-UNSTRING
       END-PERFORM.

       MOVE split-uri TO split-uri-out.
       
       DISPLAY 'Done = ' split-uri-count.
       DISPLAY 'Out  = ' split-uri-count-out.
       GOBACK.
           
       END PROGRAM split-request-uri.
