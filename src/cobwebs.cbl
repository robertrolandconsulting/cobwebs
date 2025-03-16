       >>SOURCE FREE
*>*******************************************
*> CobWebs framework main source file
*>
*> cobwebs
*>
*> Copyright (c) 2025 Robert Roland
*>*******************************************
identification division.
program-id.   cobwebs-serve.

environment division.
configuration section.
repository.
    function fcgi-accept
    function fcgi-put-ln
    function fcgi-put
    function fcgi-get-param
    function fcgi-finish
    function all intrinsic.

data division.

working-storage section.

copy 'fcgi.cpy'.
copy 'http-request.cpy'.

01  rc usage binary-long value 0.
01  rc-cbl pic s9(8).

01  accept-rc usage binary-long value 0.
01  accept-rc-cbl pic s9(8).

01  out-str pic x(100).

procedure division.
    display "CobWebs startup" upon stderr end-display

    display "Wait for request" upon stderr end-display

    move fcgi-accept(fcgx-in-handle, 
         fcgx-out-handle,
         fcgx-err-handle,
         fcgx-envp) to accept-rc

    perform until accept-rc is less than zero
       if (fcgx-in-handle equal null) or
          (fcgx-out-handle equal null) or
          (fcgx-err-handle equal null) or
          (fcgx-envp equal null)

          display 'FATAL: FCGX_Accept returned one or more null pointers, cannot continue' upon stderr
          display 'fcgx-in-handle  = ' fcgx-in-handle upon stderr
          display 'fcgx-out-handle = ' fcgx-out-handle upon stderr
          display 'fcgx-err-handle = ' fcgx-err-handle upon stderr
          display 'fcgx-envp       = ' fcgx-envp upon stderr

          stop run returning 1
       end-if

        *> build http request
       call "build-request"
            using fcgx-envp http-request
       end-call

       display 'request_uri = ' trim(request-uri in http-request) upon stderr end-display

       move fcgi-put-ln(fcgx-out-handle, 'Content-type: text/html') to rc

       move fcgi-put-ln(fcgx-out-handle, ' ') to rc

       move fcgi-put-ln(fcgx-out-handle, '<html><body>') to rc

       move fcgi-put-ln(fcgx-out-handle, '<h3>FastCGI environment with GNU Cobol</h3>') to rc

       move fcgi-put-ln(fcgx-out-handle, '</body></html>') to rc

       display "Wait for request" upon stderr end-display

       move fcgi-accept(fcgx-in-handle,
            fcgx-out-handle,
            fcgx-err-handle,
            fcgx-envp) to accept-rc
    end-perform.

end program cobwebs-serve.
