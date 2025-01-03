01  FCGX-Request.
    05  request-id usage binary-short synchronized.
    05  role       usage binary-short synchronized.
    05  stream-in  usage pointer      synchronized.
    05  stream-out usage pointer      synchronized.
    05  stream-err usage pointer      synchronized.
    05  env        usage pointer      synchronized.
    05  filler     usage pointer      synchronized. *> struct Params *paramsPtr;
    05  filler     usage binary-short synchronized. *> int ipcFd;
    05  filler     usage binary-short synchronized. *> int isBeginProcessed;
    05  filler     usage binary-short synchronized. *> int keepConnection;
    05  filler     usage binary-short synchronized. *> int appStatus;
    05  filler     usage binary-short synchronized. *> int nWriters;
    05  filler     usage binary-short synchronized. *> int flags;
    05  filler     usage binary-short synchronized. *> int listen_sock;
    05  filler     usage binary-short synchronized. *> int detached;

01  FCGX-Accept-R-return usage binary-short.

01  FCGX-Stream-In.
    05  p-rd-next           usage binary-char unsigned synchronized.
    05  p-wr-next           usage binary-char unsigned synchronized.
    05  p-stop              usage binary-char unsigned synchronized.
    05  p-stop-unget        usage binary-char unsigned synchronized.
    05  p-is-reader         usage binary-short synchronized.
    05  p-is-closed         usage binary-short synchronized.
    05  p-was-fclose-called usage binary-short synchronized.
    05  p-fcgi-errno        usage binary-short synchronized.
    05  p-fill-buff-proc    usage procedure-pointer.
    05  p-empty-buff-proc   usage procedure-pointer.
    05  filler              usage pointer.

01  FCGX-Stream-Out.
    05  p-rd-next           usage binary-char unsigned synchronized.
    05  p-wr-next           usage binary-char unsigned synchronized.
    05  p-stop              usage binary-char unsigned synchronized.
    05  p-stop-unget        usage binary-char unsigned synchronized.
    05  p-is-reader         usage binary-short synchronized.
    05  p-is-closed         usage binary-short synchronized.
    05  p-was-fclose-called usage binary-short synchronized.
    05  p-fcgi-errno        usage binary-short synchronized.
    05  p-fill-buff-proc    usage procedure-pointer.
    05  p-empty-buff-proc   usage procedure-pointer.
    05  filler              usage pointer.

01  FCGX-Stream-Err.
    05  p-rd-next           usage binary-char unsigned synchronized.
    05  p-wr-next           usage binary-char unsigned synchronized.
    05  p-stop              usage binary-char unsigned synchronized.
    05  p-stop-unget        usage binary-char unsigned synchronized.
    05  p-is-reader         usage binary-short synchronized.
    05  p-is-closed         usage binary-short synchronized.
    05  p-was-fclose-called usage binary-short synchronized.
    05  p-fcgi-errno        usage binary-short synchronized.
    05  p-fill-buff-proc    usage procedure-pointer.
    05  p-empty-buff-proc   usage procedure-pointer.
    05  filler              usage pointer.

01 FCGX-Param-Array         usage pointer.

