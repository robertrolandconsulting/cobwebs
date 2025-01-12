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

    call "FCGX_FPrintF"
    using
        by value out-handle
        by content '%s'
        by content concatenate(trim(out-str, trailing), x'00')
    returning rc
    end-call.

    display 'back from call' upon stderr end-display

    goback.

end program fcgi-display.

identification division.
program-id. fcgi-accept.

environment division.

data division.

local-storage section.

01  in-handle   usage pointer.
01  out-handle  usage pointer.
01  err-handle  usage pointer.
01  envp        usage pointer.

linkage section.

01  o-in-handle   usage pointer.
01  o-out-handle  usage pointer.
01  o-err-handle  usage pointer.
01  o-fcgx-envp   usage pointer.
01  rc          usage binary-long.

procedure division using
    by value o-in-handle
    by value o-out-handle
    by value o-err-handle
    by value o-fcgx-envp
    by value rc.

    call "FCGX_Accept"
    using
        by reference in-handle
        by reference out-handle
        by reference err-handle
        by reference envp
    returning rc
    end-call

    move in-handle to o-in-handle
    move out-handle to o-out-handle
    move err-handle to o-err-handle
    move envp to o-fcgx-envp

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
