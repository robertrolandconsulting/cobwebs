       >>SOURCE FORMAT IS FREE
*> FastCGI wrapper for fcgiapp
*> GnuCOBOL 3.2 doesn't use stdio.h for output,
*> so FastCGI needs us to fall back to their
*> lower level API.
identification division.
program-id. fcgi-display.

environment division.
configuration section.
repository.
    function all intrinsic.

data division.

linkage section.

01  out-str     pic x(100).
01  out-handle  usage pointer.
01  rc          usage binary-long value 0.

procedure division using
    by reference out-handle
    by value out-str
    by value rc.

    display 'out-handle = ' out-handle upon stderr end-display

    display out-str upon stderr end-display

    call "FCGX_FPrintF"
    using
        by value out-handle
        by content '%s'
        by content concatenate(trim(out-str, trailing), x'00')
    returning rc
    end-call.

    goback.

end program fcgi-display.

identification division.
program-id. fcgi-accept.

environment division.

data division.

linkage section.

01  in-handle   usage pointer.
01  out-handle  usage pointer.
01  err-handle  usage pointer.
01  fcgx-envp   usage pointer.
01  rc          usage binary-long.

procedure division using
    by reference in-handle
    by reference out-handle
    by reference err-handle
    by reference fcgx-envp
    by value rc.

    call "FCGX_Accept"
    using
        by reference in-handle
        by reference out-handle
        by reference err-handle
        by reference fcgx-envp
    returning rc

    goback.

end program fcgi-accept.

identification division.
program-id. fcgi-getparam.

environment division.

data division.

linkage section.

01  param-name  pic x(100).
01  fcgx-envp   usage pointer.
01  param-ptr   usage pointer.

procedure division using
    by reference param-name
    by reference fcgx-envp
    by value param-ptr.

    call "FCGX_GetParam"
    using
        by content param-name
        by reference fcgx-envp
    returning param-ptr

    goback.

end program fcgi-getparam.
