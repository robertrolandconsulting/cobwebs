       >>SOURCE FORMAT IS FREE
*> FastCGI from COBOL sample
*>   fastcgi-accept is a binary-long
*>   carriage-return is x"0d" and newline is x"0a"
identification division.
program-id.   simple.

ENVIRONMENT DIVISION.

DATA DIVISION.
FILE SECTION.

working-storage section.

COPY 'fcgi.cpy'.

01 fastcgi-accept  usage binary-short.

01 carriage-return pic x value x'0c'.
01 newline         pic x value x'0a'.

01 fcgx-request-ptr usage pointer.

procedure division.

    call 'fcgi-init'.

    set fcgx-request-ptr to address of fcgx-request.
    display 'fcgx-request-ptr = ' fcgx-request-ptr upon stderr.

    call "fcgi-initrequest"
    using by value fcgx-request-ptr 0 0.

    display "Starting" upon stderr end-display

    call "fcgi-accept-r" using fcgx-request-ptr fastcgi-accept
        on exception
            display
                "FCGI_Accept call error, link with -lfcgi"
                upon stderr
            end-display
    end-call

    display 'fcgi_accept = ' fastcgi-accept upon stderr end-display

    display 'fcgx-request-out = ' stream-out upon stderr.

    perform until fastcgi-accept is less than zero
        display "processing request" upon stderr end-display

    *> Always send out the Content-type before any other IO
        call "fcgi-display"
        using stream-out function concatenate("Content-type: text/html",  carriage-return, newline)

        call "fcgi-display"
        using stream-out "<html><body>"

        call "fcgi-display"
        using stream-out "<h3>FastCGI environment with GnuCOBOL</h3>"

*>         call "fcgi-accept-r" using fcgx-request-ptr fastcgi-accept
*>         on exception
            move -1 to fastcgi-accept
*>         end-call

        display 'fcgi_accept = ' fastcgi-accept upon stderr end-display
    end-perform.
