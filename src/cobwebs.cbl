       >>SOURCE FORMAT IS FREE
*>*******************************************
*> CobWebs framework main source file
*>
*> cobwebs
*>
*> Copyright (c) 2025 Robert Roland
*>*******************************************
identification division.
program-id.   cobwebs.

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

01 newline         pic x value x'0a'.

procedure division.

    call "FCGI_Accept" returning fastcgi-accept
        on exception
            display
                "FCGI_Accept call error, link with -lfcgi"
            end-display
    end-call

    perform until fastcgi-accept is less than zero
        *> build http request
        call "build-request"

        *> Always send out the Content-type before any other IO
        display "Content-type: text/html" newline end-display

        display "<html><body>" end-display
        display
            "<h3>FastCGI environment with GNU Cobol</h3>"
        end-display
        display "</html></body>" end-display

        call "FCGI_Accept" returning fastcgi-accept
            on exception
                move -1 to fastcgi-accept
        end-call
    end-perform.

end program cobwebs.
