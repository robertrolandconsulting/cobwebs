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

    call "fcgi-accept"
    using
        by reference fcgx-in-handle
        fcgx-out-handle
        by reference fcgx-err-handle
        by reference fcgx-envp
    returning accept-rc
    end-call

    display '2 fcgx-out-handle = ' fcgx-out-handle upon stderr end-display

    move accept-rc to accept-rc-cbl

    display "Request found with rc " accept-rc-cbl upon stderr end-display

    perform until accept-rc is less than zero
        *> build http request
        display "build http-request" upon stderr end-display
        call "build-request"
        end-call

        display "Write result" upon stderr end-display

        move concatenate('Content-type: text/html', crlf) to out-str
        call "fcgi-display"
        using
            fcgx-out-handle
            out-str
        returning rc
        end-call

        move crlf to out-str
        call "fcgi-display"
        using
            fcgx-out-handle
            out-str
        returning rc
        end-call

        move concatenate('<html><body>', crlf) to out-str
        call "fcgi-display"
        using
            fcgx-out-handle
            out-str
        returning rc
        end-call

        move concatenate('<h3>FastCGI environment with GNU Cobol</h3>', crlf) to out-str
        call "fcgi-display"
        using
            fcgx-out-handle
            out-str
        returning rc
        end-call

        move concatenate('</body></html>', crlf) to out-str
        call "fcgi-display"
        using
            fcgx-out-handle
            out-str
        returning rc
        end-call

        display "Wait for request" upon stderr end-display

        call "fcgi-accept"
        using
            by reference fcgx-in-handle
            by reference fcgx-out-handle
            by reference fcgx-err-handle
            by reference fcgx-envp
        returning accept-rc
        on exception
            move -1 to accept-rc
        end-call
    end-perform.

end program cobwebs-serve.
