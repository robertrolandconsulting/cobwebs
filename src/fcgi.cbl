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

linkage section.

01  ret-val-out usage binary-long.

procedure division
    using by value ret-val-out.

    call "FCGX_IsCGI".

    move return-code to ret-val-out.

    goback.

end program fcgi-is-cgi.

identification division.
program-id. fcgi-putstr.

environment division.

data division.

linkage section.

01  out-str     pic x(1024).
01  rc-out      usage binary-long.

procedure division using
    by reference out-str
    by value rc-out.

    call "FCGI_puts" using
    by content out-str
    end-call.

    move return-code to rc-out.

    goback.

end program fcgi-putstr.

identification division.
program-id. fcgi-accept.

environment division.

data division.

linkage section.

01  rc-out     usage binary-long.

procedure division using
    by value rc-out.

    call "FCGI_Accept".

    move return-code to rc-out.

    goback.

end program fcgi-accept.

identification division.
program-id. fcgi-accept-r.

environment division.

data division.

linkage section.

01  fcgx-request-ptr usage pointer.
01  rc-out           usage binary-long.

procedure division using
    by value fcgx-request-ptr
    by value rc-out.

    call "FCGX_Accept_r"
    using by value fcgx-request-ptr.

    move return-code to rc-out.

    goback.

end program fcgi-accept-r.

identification division.
program-id. fcgi-init.

environment division.

data division.

linkage section.

01  ret-val-out usage binary-long.

procedure division.

    call "FCGX_Init".

    move return-code to ret-val-out.

    goback.

end program fcgi-init.
