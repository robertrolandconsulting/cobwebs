       >>SOURCE FORMAT IS FREE
*>*******************************************
*> Route HTTP requests
*>
*> router
*>
*> Copyright (c) 2025 Robert Roland
*>*******************************************
identification division.
program-id. router.

data division.

working-storage section.

01  hostvars.
    05  buffer                 pic x(1024).

01  request-uri-split.
    05  request-uri-pieces occurs 10 times.
        10  request-uri-piece    pic x(80) value spaces.
    05  request-uri-count        pic s9(04).

01  route-uri-split.
    05  route-uri-pieces occurs 10 times.
        10  route-uri-piece  pic x(80) value spaces.
    05  route-uri-count      pic s9(04).

01  matched      pic x(1).
01  piece-idx    pic s9(04).

01  temp-str     pic x(1024) value spaces.

linkage section.

copy 'routing.cpy'.
copy 'fcgi.cpy'.
copy 'http-request.cpy'.

procedure division using
    by reference http-request fcgx-envp.

*> General pattern here:
*>    UNSTRING the path from the CGI request
*>    Loop over the ROUTE-TABLE
*>    IF ROUTE-METHOD matches, UNSTRING the ROUTE-PATH
*>    Loop over the parts AND check FOR matches
*>    ANY :variable name gets stored as a VALUE IN the
*>      request parameters

    >>D display 'Route scan for ' request-uri in http-request

    call 'string-split' using
         '/'
         request-uri in http-request
         request-uri-split

    move ' ' to matched

    perform varying route-idx from 1 by 1
            until route-idx > num-routes

       if request-method = route-method(route-idx)
          >>D display "Matched method at " route-idx

          call 'string-split'
               using '/' route-path(route-idx) route-uri-split

          if request-uri-count = route-uri-count
             >>D display "possible match on count"

             move 1 to piece-idx

             >>D display 'uri-count ' route-uri-count

             perform varying piece-idx
                     from 1 by 1
                     until (piece-idx > route-uri-count)
                     or (matched = 'n')
                evaluate true
                when route-uri-pieces(piece-idx)(1:1) = ':'
                   *> parse variable
                   move route-uri-pieces(piece-idx)(2:function length(route-uri-pieces(piece-idx)) - 1)
                   to temp-str

                   call 'add-request-parameter'
                   using http-request
                         function trim(temp-str, trailing)
                         function trim(request-uri-pieces(piece-idx), trailing)
                when request-uri-pieces(route-idx) not =
                route-uri-pieces(route-idx)
                   move 'n' to matched
                when other
                   move 'y' to matched
                end-evaluate
             end-perform
          end-if
       end-if
    end-perform

    >>D display 'matched = ' matched

    display parameter-key(1) '=' parameter-value(1)

    goback.

end program router.

identification division.
program-id. add-request-parameter.

data division.

linkage section.

copy 'http-request.cpy'.

01 param-name  PIC X(1024).
01 param-value PIC X(1024).

procedure division using http-request param-name param-value.

    add 1 to parameters-count.

    move param-name to parameter-key(parameters-count).
    move param-value to parameter-value(parameters-count).

    goback.

end program add-request-parameter.

identification division.
program-id. build-request.

environment division.
configuration section.
repository.
    function fcgi-get-param
    function all intrinsic.

data division.

working-storage section.

linkage section.

copy 'fcgi.cpy'.
copy 'http-request.cpy'.

procedure division using fcgx-envp http-request.

    move fcgi-get-param("AUTH_TYPE", fcgx-envp) to auth-type in http-request
    move fcgi-get-param("CONTENT_LENGTH", fcgx-envp) to content-len in http-request
    move fcgi-get-param("CONTENT_TYPE", fcgx-envp) to content-type in http-request
    move fcgi-get-param("DATE_LOCAL", fcgx-envp) to date-local in http-request
    move fcgi-get-param("DATE_GMT", fcgx-envp) to date-gmt in http-request
    move fcgi-get-param("DOCUMENT_NAME", fcgx-envp) to document-name in http-request
    move fcgi-get-param("DOCUMENT_ROOT", fcgx-envp) to document-root in http-request
    move fcgi-get-param("DOCUMENT_URI", fcgx-envp) to document-uri in http-request
    move fcgi-get-param("FORWARDED", fcgx-envp) to forwarded in http-request
    move fcgi-get-param("FROM", fcgx-envp) to frm in http-request
    move fcgi-get-param("GATEWAY_INTERFACE", fcgx-envp) to gateway-interface in http-request
    move fcgi-get-param("HTTP_ACCEPT", fcgx-envp) to http-accept in http-request
    move fcgi-get-param("HTTP_ACCEPT_CHARSET", fcgx-envp) to http-accept-charset in http-request
    move fcgi-get-param("HTTP_ACCEPT_ENCODING", fcgx-envp) to http-accept-encoding in http-request
    move fcgi-get-param("HTTP_ACCEPT_LANGUAGE", fcgx-envp) to http-accept-language in http-request
    move fcgi-get-param("HTTP_CACHE_CONTROL", fcgx-envp) to http-cache-control in http-request
    move fcgi-get-param("HTTP_CONNECTION", fcgx-envp) to http-connection in http-request
    move fcgi-get-param("HTTP_COOKIE", fcgx-envp) to http-cookie in http-request
    move fcgi-get-param("HTTP_FORM", fcgx-envp) to http-form in http-request
    move fcgi-get-param("HTTP_HOST", fcgx-envp) to http-host in http-request
    move fcgi-get-param("HTTP_REFERRER", fcgx-envp) to http-referrer in http-request
    move fcgi-get-param("HTTP_UA_COLOR", fcgx-envp) to http-ua-color in http-request
    move fcgi-get-param("HTTP_UA_CPU", fcgx-envp) to http-ua-cpu in http-request
    move fcgi-get-param("HTTP_UA_OS", fcgx-envp) to http-ua-os in http-request
    move fcgi-get-param("HTTP_UA_PIXELS", fcgx-envp) to http-ua-pixels in http-request
    move fcgi-get-param("HTTP_USER_AGENT", fcgx-envp) to http-user-agent in http-request
    move fcgi-get-param("HTTP_X_FORWARDED_FOR", fcgx-envp) to http-x-forwarded-for in http-request
    move fcgi-get-param("INSTANCE_ID", fcgx-envp) to instance-id in http-request
    move fcgi-get-param("LAST_MODIFIED", fcgx-envp) to last-modified in http-request
    move fcgi-get-param("PAGE_COUNT", fcgx-envp) to page-count in http-request
    move fcgi-get-param("PATH", fcgx-envp) to path in http-request
    move fcgi-get-param("PATH_INFO", fcgx-envp) to path-info in http-request
    move fcgi-get-param("PATH_TRANSLATED", fcgx-envp) to path-translated in http-request
    move fcgi-get-param("QUERY_STRING", fcgx-envp) to query-string in http-request
    move fcgi-get-param("QUERY_STRING_UNESCAPED", fcgx-envp) to query-string-unescaped in http-request
    move fcgi-get-param("REMOTE_ADDR", fcgx-envp) to remote-addr in http-request
    move fcgi-get-param("REMOTE_HOST", fcgx-envp) to remote-host in http-request
    move fcgi-get-param("REMOTE_IDENT", fcgx-envp) to remote-ident in http-request
    move fcgi-get-param("REMOTE_PORT", fcgx-envp) to remote-port in http-request
    move fcgi-get-param("REMOTE_USER", fcgx-envp) to remote-user in http-request
    move fcgi-get-param("REQUEST_METHOD", fcgx-envp) to request-method in http-request
    move fcgi-get-param("REQUEST_URI", fcgx-envp) to request-uri in http-request
    move fcgi-get-param("SCRIPT_FILENAME", fcgx-envp) to script-filename in http-request
    move fcgi-get-param("SCRIPT_NAME", fcgx-envp) to script-name in http-request
    move fcgi-get-param("SCRIPT_URI", fcgx-envp) to script-uri in http-request
    move fcgi-get-param("SCRIPT_URL", fcgx-envp) to script-url in http-request
    move fcgi-get-param("SERVER_ADMIN", fcgx-envp) to server-admin in http-request
    move fcgi-get-param("SERVER_ADDR", fcgx-envp) to server-addr in http-request
    move fcgi-get-param("SERVER_NAME", fcgx-envp) to server-name in http-request
    move fcgi-get-param("SERVER_PORT", fcgx-envp) to server-port in http-request
    move fcgi-get-param("SERVER_PROTOCOL", fcgx-envp) to server-protocol in http-request
    move fcgi-get-param("SERVER_SIGNATURE", fcgx-envp) to server-signature in http-request
    move fcgi-get-param("SERVER_SOFTWARE", fcgx-envp) to server-software in http-request
    move fcgi-get-param("TOTAL_HITS", fcgx-envp) to total-hits in http-request
    move fcgi-get-param("TZ", fcgx-envp) to tz in http-request
    move fcgi-get-param("UNIQUE_ID", fcgx-envp) to unique-id in http-request
    move fcgi-get-param("USER_NAME", fcgx-envp) to user-name in http-request
    move fcgi-get-param("VISP_DOMAIN", fcgx-envp) to visp-domain in http-request
    move fcgi-get-param("VISP_REMOTE_ADDR", fcgx-envp) to visp-remote-addr in http-request
    move fcgi-get-param("VISP_USER", fcgx-envp) to visp-user in http-request

    goback.
end program build-request.
