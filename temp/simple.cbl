       >>SOURCE FORMAT IS FREE
*> FastCGI from COBOL sample
*>   fastcgi-accept is a binary-long
*>   carriage-return is x"0d" and newline is x"0a"
identification division.
program-id.   simple.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT OPTIONAL OUT-FILE ASSIGN "log.txt"
    ORGANIZATION LINE SEQUENTIAL.
DATA DIVISION.
FILE SECTION.
FD OUT-FILE.
   01 log-message pic x(1024).

working-storage section.

01 fastcgi-accept  usage binary-long.

01 carriage-return pic x value x'0c'.
01 newline         pic x value x'0a'.

procedure division.

 OPEN OUTPUT out-file.
 move 'start' to log-message.
 write log-message.

 call "FCGI_Accept" returning fastcgi-accept
     on exception
         display
             "FCGI_Accept call error, link with -lfcgi"
         end-display
 end-call

 move fastcgi-accept to log-message.
 write log-message.

 perform until fastcgi-accept is less than zero
     move 'processing request' to log-message
     write log-message

*> Always send out the Content-type before any other IO
     display "Content-type: text/html" carriage-return newline
     end-display

     display "<html><body>" end-display
     display
         "<h3>FastCGI environment with GnuCOBOL</h3>"
     end-display

     call "FCGI_Accept" returning fastcgi-accept
         on exception
             move -1 to fastcgi-accept
     end-call
     move fastcgi-accept to log-message
     write log-message

 end-perform.
