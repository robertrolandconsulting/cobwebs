       >>SOURCE FORMAT IS FREE
*> FastCGI wrapper for fcgiapp
*> GnuCOBOL 3.2 doesn't use stdio.h for output,
*> so FastCGI needs us to fall back to their
*> lower level API.
identification division.
function-id. fcgi-put.

environment division.
configuration section.
repository.
    function all intrinsic.

data division.

linkage section.

01  out-str     pic x any length.
01  out-handle  usage pointer.
01  rc          usage binary-long value 0.

procedure division using
    by reference out-handle
    by reference out-str
    returning rc.

    call "FCGX_FPrintF"
    using
        by value out-handle
        by content z'%s'
        by content concatenate(trim(out-str, trailing), x'00')
    returning rc
    end-call.

    goback.

end function fcgi-put.

identification division.
function-id. fcgi-put-ln.

environment division.
configuration section.
repository.
    function all intrinsic.

data division.

linkage section.

01  out-str     pic x any length.
01  out-handle  usage pointer.
01  rc          usage binary-long value 0.

procedure division using
    by reference out-handle
    by reference out-str
    returning rc.

    call "FCGX_FPrintF"
    using
        by value out-handle
        by content z'%s'
        by content concatenate(trim(out-str, trailing), x'0d', x'0a', x'00')
    returning rc
    end-call.

    goback.

end function fcgi-put-ln.

identification division.
function-id. fcgi-accept.

environment division.

data division.

local-storage section.

linkage section.

01  in-handle   usage pointer.
01  out-handle  usage pointer.
01  err-handle  usage pointer.
01  envp        usage pointer.
01  rc          usage binary-long.

procedure division
    using in-handle out-handle err-handle envp returning rc.

    call "FCGX_Accept"
    using
        by reference in-handle
        by reference out-handle
        by reference err-handle
        by reference envp
    returning rc.

    goback.

end function fcgi-accept.

identification division.
function-id. fcgi-finish.

environment division.

data division.

local-storage section.

linkage section.

01 rc pic s9(4) value 0.

procedure division returning rc.

    call "FCGX_Finish".

    goback.

end function fcgi-finish.

identification division.
function-id. fcgi-get-param.

environment division.
configuration section.
repository.
    function all intrinsic.

data division.

local-storage section.

01  param-ptr     usage pointer.
01  local-string  pic x(1024).
01  c-char-buffer pic x(1024) based.

linkage section.

01  param-name  pic x any length.
01  fcgx-envp   usage pointer.
01  param-value pic x(1024).

procedure division using
    by reference param-name
    by reference fcgx-envp
    returning param-value.

    call "FCGX_GetParam"
    using
        by content concatenate(trim(param-name, trailing), x'00')
        by value fcgx-envp
    returning param-ptr

    if param-ptr not equal null
        set address of c-char-buffer to param-ptr
        string c-char-buffer delimited by x"00"
            into local-string
        end-string
        move local-string to param-value
    else
        move spaces to param-value
    end-if

    goback.
end function fcgi-get-param.
