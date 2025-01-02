       >>SOURCE FORMAT IS FREE
*>*******************************************
*> Route HTTP requests
*>
*> router
*>
*> Copyright (c) 2024 Robert Roland
*>*******************************************
identification division.
program-id.   router.

data division.

working-storage section.

01  hostvars.
    05  buffer                 pic x(1024).

01  router-config.
    05  num-routes             pic s9(04) comp.
    05  route-table occurs 10 times indexed by route-idx.
*> GET / POST / PUT / PATCH / DELETE / HEAD
        10 route-method        pic x(6).
        10 route-path          pic x(1024).
        10 route-destination   pic x(100).

copy 'http-request.cpy'.

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

procedure division.

    display "Testing routing".

    move 'PUT' to route-method(1).
    move '/api/foo' to route-path(1).

    move 'GET' to route-method(2).
    move '/api/foo/:bar' to route-path(2).

    move 2 to num-routes.

    move 'GET' to request-method.
    move '/api/foo/1234' to request-uri.

    display "There are " num-routes " routes defined".

    perform match-route

    display "Done".
    goback.

match-route.

*> General pattern here:
*>    UNSTRING the path from the CGI request
*>    Loop over the ROUTE-TABLE
*>    IF ROUTE-METHOD matches, UNSTRING the ROUTE-PATH
*>    Loop over the parts AND check FOR matches
*>    ANY :variable name gets stored as a VALUE IN the
*>      request parameters

    >>D display 'Route scan for ' request-uri

    call 'string-split'
         using '/' request-uri request-uri-split

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

    display request-parameter-key(1) '=' request-parameter-value(1)

    goback.

identification division.
program-id. add-request-parameter.

data division.

linkage section.

copy 'http-request.cpy'.

    01 param-name  PIC X(1024).
    01 param-value PIC X(1024).

procedure division using http-request param-name param-value.

    add 1 to request-parameters-count.

    move param-name to request-parameter-key(request-parameters-count).
    move param-value to request-parameter-value(request-parameters-count).

    goback.

end program add-request-parameter.

identification division.
program-id. build-request.

data division.

working-storage section.

copy 'http-request.cpy'.

procedure division.

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

    goback.
end program build-request.

end program router.
