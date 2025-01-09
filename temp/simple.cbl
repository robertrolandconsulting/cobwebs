       >>SOURCE FORMAT IS FREE
identification division.
program-id. simple.

environment division.
configuration section.
repository.
    function all intrinsic.

data division.
file section.

working-storage section.

01 fastcgi-accept-rc  usage binary-long.
01 fastcgi-putstr-rc  usage binary-long.

01 carriage-return pic x value x'0d'.
01 newline         pic x value x'0a'.

procedure division.
    call "fcgi-accept"
    using fastcgi-accept-rc
    on exception
        display
            "FCGI_Accept call error, link with -lfcgi"
            upon stderr
        end-display
        stop run
    end-call

    perform until fastcgi-accept-rc is less than zero
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
    end-perform.
