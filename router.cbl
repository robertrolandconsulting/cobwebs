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
           05  buffer                 PIC X(1024).

       01  router-config.
           05  num-routes             PIC S9(04) COMP.
           05  route-table OCCURS 10 TIMES INDEXED BY route-idx.
      * GET / POST / PUT / PATCH / DELETE / HEAD
               10 route-method        PIC X(6).
               10 route-path          PIC X(1024).
               10 route-destination   PIC X(100).

       01  http-request.
           05  request-uri                 PIC X(1024).
           05  request-method              PIC X(6).
           05  request-auth-type           PIC X(100).
           05  request-content-length      PIC S9(04).
           05  request-date-local          PIC X(50).
           05  request-date-gmt            PIC X(50).
           05  request-document-name       PIC X(100).
           05  request-document-root       PIC X(100).
           05  request-document-uri        PIC X(100).
           05  request-forwarded           PIC X(1024).
           05  request-from                PIC X(1024).
           05  request-gateway-interface   PIC X(1024).
           05  request-http-accept         PIC X(1024).
           05  request-http-accept-charset PIC X(1024).
           05  request-http-accept-encoding PIC X(1024).
           05  request-http-accept-language PIC X(1024).
           05  request-cache-control        PIC X(1024).
           05  request-connection           PIC X(1024).
           05  request-http-cookie          PIC X(8192).
           05  request-http-form            PIC X(8192).
           05  request-http-host            PIC X(100).
           05  request-http-referrer        PIC X(1024).
           05  request-http-ua-color        PIC X(50).
           05  request-ua-cpu               PIC X(50).
           05  request-ua-os                PIC X(50).
           05  request-ua-pixels            PIC x(50).
           05  request-user-agent           PIC X(1024).
           05  request-x-forwarded-for      PIC X(1024).
           05  request-instance-id          PIC X(1024).
           05  request-last-modified        PIC X(50).
           05  request-page-count           PIC X(10).
           05  request-path                 PIC X(4096).
           05  request-path-info            PIC X(1024).
           05  request-query-string         PIC X(1024).
           05  request-query-string-unescaped PIC X(1024).
           05  request-remote-addr          PIC X(1024).
           05  request-remote-host          PIC X(1024).
           05  request-remote-ident         PIC X(1024).
           05  request-remote-port          PIC X(100).
           05  request-script-filename      PIC X(1024).
           05  request-script-name          PIC X(1024).
           05  request-script-uri           PIC X(1024).
           05  request-script-url           PIC X(1024).
           05  request-server-admin         PIC X(1024).
           05  request-server-name          PIC X(1024).
           05  request-server-port          PIC X(100).
           05  request-server-protocol      PIC X(100).
           05  request-server-signature     PIC X(1024).
           05  request-server-software      PIC X(1024).
           05  request-total-hits           PIC X(100).
           05  request-tz                   PIC X(100).
           05  request-unique-id            PIC X(100).
           05  request-user-name            PIC X(100).
           05  request-visp-remote-addr     PIC X(1024).
           05  request-visp-user            PIC X(1024).
           05  request-headers OCCURS 10 TIMES.
               10  request-header-key      PIC X(80) VALUE SPACES.
               10  request-header-value    PIC X(1024) VALUE SPACES.
           05  request-headers-count       PIC S9(04).
           05  request-parameters OCCURS 10 TIMES.
               10  request-parameter-key   PIC X(80) VALUE SPACES.
               10  request-parameter-value PIC X(1024) VALUE SPACES.
           05  request-parameters-count    PIC S9(04).

       01  request-uri-split.
           05  request-uri-pieces OCCURS 10 TIMES.
               10  request-uri-piece    PIC X(80) VALUE SPACES.
           05  request-uri-count        PIC S9(04).

       01  route-uri-split.
           05  route-uri-pieces OCCURS 10 TIMES.
               10  route-uri-piece  PIC X(80) VALUE SPACES.
           05  route-uri-count      PIC S9(04).

       01  matched      PIC X(1).
       01  piece-idx    PIC S9(04).

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

           DISPLAY 'Route scan for ' request-uri

      * Split UP the user request STRING INTO an array
           CALL 'string-split'
                USING '/' request-uri request-uri-split

           MOVE ' ' TO matched

           PERFORM VARYING route-idx FROM 1 BY 1
                   UNTIL route-idx > num-routes

              IF request-method = route-method(route-idx)
                 DISPLAY "Matched method at " route-idx

                 CALL 'string-split'
                      USING '/' route-path(route-idx) route-uri-split

                 IF request-uri-count = route-uri-count
                    DISPLAY "possible match on count"

                    MOVE 1 TO piece-idx

                    DISPLAY 'uri-count ' route-uri-count

                    PERFORM VARYING piece-idx
                            FROM 1 BY 1
                            UNTIL (piece-idx > route-uri-count)
                            OR (matched = 'n')
                       EVALUATE TRUE
                       WHEN route-uri-pieces(piece-idx)(1:1) = ':'
      * parse variable
                          DISPLAY 'var = ' route-uri-pieces(piece-idx)
                       WHEN request-uri-pieces(route-idx) NOT =
                       route-uri-pieces(route-idx)
                          MOVE 'n' to matched
                       WHEN OTHER
                          MOVE 'y' to matched
                       END-EVALUATE
                    END-PERFORM
                 END-IF
           END-PERFORM

           DISPLAY 'matched = ' matched

           GOBACK.
       END PROGRAM router.
