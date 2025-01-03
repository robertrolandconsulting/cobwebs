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
program-id. fcgi-init.

environment division.

data division.

working-storage section.

linkage section.

procedure division.

    call "FCGX_Init".

    goback.

end program fcgi-init.

identification division.
program-id. fcgi-display.

environment division.

data division.

working-storage section.

linkage section.

01  fcgx-request-out-ptr usage pointer.
01  out-str     pic x any length.

procedure division using
    by value fcgx-request-out-ptr
    by value out-str.

    display 'call FCGX_FPrintF with out stream ptr = ' fcgx-request-out-ptr
    upon stderr.

    call "FCGX_FPrintF" using
        by value fcgx-request-out-ptr
        by reference out-str
        on exception
            display "fprintf exception" upon syserr
    end-call.

    goback.

end program fcgi-display.

identification division.
program-id. fcgi-initrequest.

environment division.

data division.

working-storage section.

linkage section.

01  fcgx-request-ptr usage pointer.
01  sock             usage binary-short.
01  flags            usage binary-short.

procedure division using
    by value fcgx-request-ptr
    by value sock
    by value flags.

    call "FCGX_InitRequest" using
    by value fcgx-request-ptr
    by value sock
    by value flags.

    *> call 'CBL_OC_DUMP' using fcgx-request-ptr.

    goback.

end program fcgi-initrequest.

identification division.
program-id. fcgi-accept-r.

environment division.

data division.

working-storage section.

01  rc usage binary-short.

linkage section.

01  fcgx-request-ptr usage pointer.
01  rc-out usage binary-short.

procedure division using
    by value fcgx-request-ptr
    by value rc-out.

    call "FCGX_Accept_r" using
    by value fcgx-request-ptr
    returning rc.

    move rc to rc-out.

    *> call 'CBL_OC_DUMP' using fcgx-request-ptr.

    goback.

end program fcgi-accept-r.

