       >>SOURCE FORMAT IS FREE
*> FastCGI wrapper for fcgiapp
*> GnuCOBOL 3.2 doesn't use stdio.h for output,
*> so FastCGI needs us to fall back to their
*> lower level API.
identification division.
program-id. fcgi-display.

environment division.

data division.

working-storage section.

linkage section.

01  request-out usage pointer.
01  out-str     pic x any length.

procedure division using out-str.

call "FCGX_FPrintF" using
by value request-out
by content function concatenate(function trim(out-str), x"00").

goback.

end program fcgi-display.

identification division.
program-id. fcgi-initrequest.

environment division.

data division.

working-storage section.

linkage section.

COPY 'fcgi.cpy'.

01  sock        usage binary-short.
01  flags       usage binary-short.

procedure division using fcgx-request sock flags.

call "FCGX_InitRequest" using
by value fcgx-request
by value sock
by value flags.

goback.

end program fcgi-initrequest.

