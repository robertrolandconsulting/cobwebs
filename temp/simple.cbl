       >>SOURCE FORMAT IS FREE
*> FastCGI from COBOL sample
*>   fastcgi-accept is a binary-long
*>   carriage-return is x"0d" and newline is x"0a"
identification division.
program-id.   simple.

ENVIRONMENT DIVISION.
configuration section.
repository.
    function all intrinsic.

DATA DIVISION.
FILE SECTION.

working-storage section.

01 fastcgi-accept-rc  usage binary-long.
01 fastcgi-putstr-rc  usage binary-long.

01 carriage-return pic x value x'0d'.
01 newline         pic x value x'0a'.

procedure division.
*>     display "Starting" upon stderr end-display

    call "fcgi-accept"
    using fastcgi-accept-rc
    on exception
        display
            "FCGI_Accept call error, link with -lfcgi"
            upon stderr
        end-display
    end-call

*>     display 'fcgi_accept = ' fastcgi-accept-rc upon stderr end-display

    perform until fastcgi-accept-rc is less than zero
*>         display "processing request" upon stderr end-display

    *> Always send out the Content-type before any other IO

        call "fcgi-putstr"
        using
            concatenate('Content-type: text/plain', newline, carriage-return, x'00')
            fastcgi-putstr-rc
        end-call

        call "fcgi-putstr"
        using
            concatenate('foo', newline, carriage-return, x'00')
            fastcgi-putstr-rc
        end-call

        call "fcgi-accept"
        using fastcgi-accept-rc
        end-call

*>         display 'fcgi_accept = ' fastcgi-accept-rc upon stderr end-display
    end-perform.
