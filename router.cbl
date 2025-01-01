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

       COPY 'http-request.cpy'.

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

       IDENTIFICATION DIVISION.
       PROGRAM-ID. build-request.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY 'http-request.cpy'.

       PROCEDURE DIVISION.

           accept request-auth-type
                  from environment "auth_type"
           end-accept
           accept request-content-length
                  from environment "content_length"
           end-accept
           accept request-content-type
                  from environment "content_type"
           end-accept
           accept request-date-local
                  from environment "date_local"
           end-accept
           accept request-date-gmt
                  from environment "date_gmt"
           end-accept
           accept request-document-name
                  from environment "document_name"
           end-accept
           accept request-document-root
                  from environment "document_root"
           end-accept
           accept request-document-uri
                  from environment "document_uri"
           end-accept
           accept request-forwarded
                  from environment "forwarded"
           end-accept
           accept request-from
                  from environment "from"
           end-accept
           accept request-gateway-interface
                  from environment "gateway_interface"
           end-accept
           accept request-http-accept
                  from environment "http_accept"
           end-accept
           accept request-http-accept-charset
                  from environment "http_accept_charset"
           end-accept
           accept request-http-accept-encoding
                  from environment "http_accept_encoding"
           end-accept
           accept request-http-accept-language
                  from environment "http_accept_language"
           end-accept
           accept request-http-cache-control
                  from environment "http_cache_control"
           end-accept
           accept request-http-connection
                  from environment "http_connection"
           end-accept
           accept request-http-cookie
                  from environment "http_cookie"
           end-accept
           accept request-http-form
                  from environment "http_form"
           end-accept
           accept request-http-host
                  from environment "http_host"
           end-accept
           accept request-http-referrer
                  from environment "http_referrer"
           end-accept
           accept request-http-ua-color
                  from environment "http_ua_color"
           end-accept
           accept request-http-ua-cpu
                  from environment "http_ua_cpu"
           end-accept
           accept request-http-ua-os
                  from environment "http_ua_os"
           end-accept
           accept request-http-ua-pixels
                  from environment "http_ua_pixels"
           end-accept
           accept request-http-user-agent
                  from environment "http_user_agent"
           end-accept
           accept request-http-x-forwarded-for
                  from environment "http_x_forwarded_for"
           end-accept
           accept request-instance-id
                  from environment "instance_id"
           end-accept
           accept request-last-modified
                  from environment "last_modified"
           end-accept
           accept request-page-count
                  from environment "page_count"
           end-accept
           accept request-path
                  from environment "path"
           end-accept
           accept request-path-info
                  from environment "path_info"
           end-accept
           accept request-path-translated
                  from environment "path_translated"
           end-accept
           accept request-query-string
                  from environment "query_string"
           end-accept
           accept request-query-string-unescaped
                  from environment "query_string_unescaped"
           end-accept
           accept request-remote-addr
                  from environment "remote_addr"
           end-accept
           accept request-remote-host
                  from environment "remote_host"
           end-accept
           accept request-remote-ident
                  from environment "remote_ident"
           end-accept
           accept request-remote-port
                  from environment "remote_port"
           end-accept
           accept request-remote-user
                  from environment "remote_user"
           end-accept
           accept request-method
                  from environment "request_method"
           end-accept
           accept request-uri
                  from environment "request_uri"
           end-accept
           accept request-script-filename
                  from environment "script_filename"
           end-accept
           accept request-script-name
                  from environment "script_name"
           end-accept
           accept request-script-uri
                  from environment "script_uri"
           end-accept
           accept request-script-url
                  from environment "script_url"
           end-accept
           accept request-server-admin
                  from environment "server_admin"
           end-accept
           accept request-server-addr
                  from environment "server_addr"
           end-accept
           accept request-server-name
                  from environment "server_name"
           end-accept
           accept request-server-port
                  from environment "server_port"
           end-accept
           accept request-server-protocol
                  from environment "server_protocol"
           end-accept
           accept request-server-signature
                  from environment "server_signature"
           end-accept
           accept request-server-software
                  from environment "server_software"
           end-accept
           accept request-total-hits
                  from environment "total_hits"
           end-accept
           accept request-tz
                  from environment "tz"
           end-accept
           accept request-unique-id
                  from environment "unique_id"
           end-accept
           accept request-user-name
                  from environment "user_name"
           end-accept
           accept request-visp-domain
                  from environment "visp_domain"
           end-accept
           accept request-visp-remote-addr
                  from environment "visp_remote_addr"
           end-accept
           accept request-visp-user
                  from environment "visp_user"
           end-accept

           GOBACK.
       END PROGRAM build-request.

       END PROGRAM router.
