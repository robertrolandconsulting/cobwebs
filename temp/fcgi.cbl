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
program-id. fcgi-display.

environment division.

data division.

working-storage section.

01  rc          usage binary-short.

linkage section.

01  out-ptr     usage pointer.
01  out-str     pic x any length.

procedure division using
    by value out-ptr
    by value out-str.

    display 'call FCGX_FPrintF with out stream ptr = ' out-ptr
    upon stderr.

    call "FCGX_FPrintF" using
    by value out-ptr
    by content function concatenate('Content-type: text/plain', x'00')
    returning rc
    on exception
        display "fprintf exception" upon syserr
    end-call.

    display 'rc = ' rc upon stderr.

    goback.

end program fcgi-display.

identification division.
program-id. fcgi-accept.

environment division.

data division.

local-storage section.

01  rc usage binary-short value 0.

linkage section.

01  stream-in  usage pointer.
01  stream-out usage pointer.
01  stream-err usage pointer.
01  envp       usage pointer.
01  rc-out     usage binary-short.

procedure division using
    by value stream-in
    by value stream-out
    by value stream-err
    by value envp
    by value rc-out.

    display 'call FCGX_Accept' upon stderr.
    display 'fcgx-request-in = ' stream-in upon stderr.
    display 'fcgx-request-out = ' stream-out upon stderr.
    display 'fcgx-request-err = ' stream-err upon stderr.
    display 'fcgx-envp = ' envp upon stderr.

    call "FCGX_Accept" using
    by value stream-in
    by value stream-out
    by value stream-err
    by value envp
    returning rc.

    move rc to rc-out.

    display 'rc = ' rc upon stderr.

    *> call 'CBL_OC_DUMP' using fcgx-request-ptr.

    goback.

end program fcgi-accept.

