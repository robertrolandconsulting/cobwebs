       >>SOURCE FORMAT IS FREE
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

    display '1 fcgx-out-handle = ' fcgx-out-handle upon stderr end-display

    move fcgi-accept(fcgx-in-handle, 
        fcgx-out-handle,
        fcgx-err-handle,
        fcgx-envp) to accept-rc

    display '2 fcgx-out-handle = ' fcgx-out-handle upon stderr end-display

    move accept-rc to accept-rc-cbl

    display "Request found with rc " accept-rc-cbl upon stderr end-display

    perform until accept-rc is less than zero
        display 'request_uri = ' fcgi-get-param('REQUEST_URI', fcgx-envp) upon stderr end-display

        *> build http request
        call "build-request"
        end-call

        display "Write result" upon stderr end-display

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
