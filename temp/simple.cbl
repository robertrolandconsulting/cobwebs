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

01 fastcgi-accept-rc  usage binary-long.

01 carriage-return pic x value x'0c'.
01 newline         pic x value x'0a'.

01 fcgx-request-ptr usage pointer.

procedure division.
    display "Starting" upon stderr end-display

    call "fcgi-accept"
    using FCGX-Stream-In
          FCGX-Stream-Out
          FCGX-Stream-Err
          FCGX-Param-Array
          fastcgi-accept-rc
    on exception
        display
            "FCGI_Accept call error, link with -lfcgi"
            upon stderr
        end-display
    end-call

    display 'fcgi_accept = ' fastcgi-accept-rc upon stderr end-display

    display 'fcgx-request-out = ' FCGX-Stream-Out upon stderr.

    perform until fastcgi-accept-rc is less than zero
        display "processing request" upon stderr end-display

    *> Always send out the Content-type before any other IO
        call "fcgi-display"
        using FCGX-Stream-Out function concatenate("Content-type: text/html",  carriage-return, newline)

        call "fcgi-display"
        using FCGX-Stream-Out "<html><body>"

        call "fcgi-display"
        using FCGX-Stream-Out "<h3>FastCGI environment with GnuCOBOL</h3>"

        call "fcgi-accept"
        using FCGX-Stream-In
              FCGX-Stream-Out
              FCGX-Stream-Err
              FCGX-Param-Array
              fastcgi-accept-rc
        on exception
            move -1 to fastcgi-accept-rc
        end-call

        display 'fcgi_accept = ' fastcgi-accept-rc upon stderr end-display
    end-perform.
