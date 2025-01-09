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

input-output section.

file-control.
    select webinput assign to KEYBOARD.

data division.

file section.

fd webinput.
    01 chunk-of-post   pic x(1024).

working-storage section.

copy 'http-request.cpy'.

01 fastcgi-accept  usage binary-long.

01 carriage-return pic x value x'0d'.
01 newline         pic x value x'0a'.

procedure division.
    call "fcgi-accept"
    using fastcgi-accept
    on exception
        display
            "FCGI_Accept call error, link with -lfcgi"
            upon stderr
        end-display
        stop run
    end-call

    perform until fastcgi-accept is less than zero
        *> build http request
        call "build-request"
        end-call

        display "request-uri = " request-uri upon stderr end-display

        *> Always send out the Content-type before any other IO
        display "Content-type: text/html" newline end-display

        display "<html><body>" end-display
        display
            "<h3>FastCGI environment with GNU Cobol</h3>"
        end-display
        display "</html></body>" end-display

        call "fastcgi-accept" using fastcgi-accept
        on exception
            move -1 to fastcgi-accept
        end-call
    end-perform.

end program cobwebs-serve.
