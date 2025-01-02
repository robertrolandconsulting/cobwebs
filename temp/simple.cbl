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

01 fastcgi-accept  usage binary-long.

01 carriage-return pic x value x'0c'.
01 newline         pic x value x'0a'.

procedure division.

    call "fcgi-initrequest"
    using fcgx-request 0 0.

    display 'out = ' stream-out.

 display "Starting" upon stderr end-display

 call "FCGI_Accept" returning fastcgi-accept
     on exception
         display
             "FCGI_Accept call error, link with -lfcgi"
             upon stderr
         end-display
 end-call

 display 'fcgi_accept = ' fastcgi-accept upon stderr end-display

 perform until fastcgi-accept is less than zero
     display "processing request" upon stderr end-display

*> Always send out the Content-type before any other IO
     display "Content-type: text/html" carriage-return newline upon stdout
     end-display

     display "<html><body>"  upon stdout end-display
     display
         "<h3>FastCGI environment with GnuCOBOL</h3>"
          upon stdout
     end-display

     call "FCGI_Accept" returning fastcgi-accept
         on exception
             move -1 to fastcgi-accept
     end-call

     display 'fcgi_accept = ' fastcgi-accept upon stderr end-display

 end-perform.
