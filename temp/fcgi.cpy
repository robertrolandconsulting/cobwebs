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
