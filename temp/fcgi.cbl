       >>SOURCE FORMAT IS FREE
*> FastCGI wrapper for fcgiapp
*> GnuCOBOL 3.2 doesn't use stdio.h for output,
*> so FastCGI needs us to fall back to their
*> lower level API.
identification division.
program-id. fcgi-is-cgi.

environment division.

data division.

local-storage section.

01  ret-val     binary-short value 0.

linkage section.

01  ret-val-out binary-short.

procedure division.

    call "FCGX_IsCGI"
    returning ret-val.

    move ret-val to ret-val-out.

    goback.

end program fcgi-is-cgi.

identification division.
program-id. fcgi-putstr.

environment division.

data division.

local-storage section.

01  rc usage binary-long value 0.

linkage section.

01  out-str     pic x(1024).
01  rc-out      usage binary-long.

procedure division using
    by reference out-str
    by value rc-out.

    call "FCGI_puts" using
    by content out-str
    returning rc
    end-call.

    move rc to rc-out.

    goback.

end program fcgi-putstr.

identification division.
program-id. fcgi-accept.

environment division.

data division.

local-storage section.

01  rc usage binary-long value 0.

linkage section.

01  rc-out     usage binary-long.

procedure division using
    by value rc-out.

    call "FCGI_Accept"
    returning rc.

    move rc to rc-out.

    goback.

end program fcgi-accept.

