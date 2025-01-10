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

input-output section.

file-control.
    select webinput assign to KEYBOARD.

data division.

file section.

fd webinput.
    01  chunk-of-post   pic x(1024).

working-storage section.

copy 'fcgi.cpy'.
copy 'http-request.cpy'.

01  init-rc            usage binary-long value 0.
01  fastcgi-accept     usage binary-long value 0.
01  fastcgi-putstr-rc  usage binary-long value 0.

01  crlf.
    05  cr pic x value x'0d'.
    05  lf pic x value x'0a'.

procedure division.
    display "CobWebs startup" upon stderr end-display

    display "call fcgi-init" upon stderr end-display
    call "fcgi-init"
    end-call

    move return-code to init-rc

    display "back from fcgi-init with " init-rc upon stderr end-display

    if init-rc less than zero
        display "Fatal: FCGX_Init returned " init-rc upon stderr
        exit program returning init-rc
    end-if

    display "Wait for request" upon stderr end-display

    call "FCGX_Accept_r"
    using by reference FCGX-Request
    on exception
        display
            "FCGX_Accept_r call error, link with -lfcgi"
            upon stderr
        end-display
        stop run
    end-call

    move return-code to fastcgi-accept

    display "Request found with rc " fastcgi-accept upon stderr end-display

    set address of FCGX-Stream-In to in-ptr.
    set address of FCGX-Stream-Out to out-ptr.
    set address of FCGX-Stream-Err to err-ptr.

    perform until fastcgi-accept is less than zero
        *> build http request
        display "build http-request" upon stderr end-display
        call "build-request"
        end-call

        display "Write result" upon stderr end-display

        call "FCGX_PutS"
        using
            by content concatenate('Content-type: text/html', crlf, x'00')
            by reference FCGX-Stream-Out
        end-call

        call "FCGX_PutS"
        using
            by content concatenate('<html><body>', crlf, x'00')
            by reference FCGX-Stream-Out
        end-call

        call "FCGX_PutS"
        using
            by content concatenate("<h3>FastCGI environment with GNU Cobol</h3>", crlf, x'00')
            by reference FCGX-Stream-Out
        end-call

        call "FCGX_PutS"
        using
            by content concatenate('</body></html>', crlf, x'00')
            by reference FCGX-Stream-Out
        end-call

        display "Wait for request" upon stderr end-display

        call "FCGX_Accept_r"
        using by reference FCGX-Request
        on exception
            move -1 to fastcgi-accept
        not on exception
            move return-code to fastcgi-accept
        end-call
    end-perform.

end program cobwebs-serve.
