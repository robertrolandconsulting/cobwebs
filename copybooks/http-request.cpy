01  http-request.
    05  request-uri          PIC X(1024).
    05  request-method       PIC X(6).
    05  auth-type            PIC X(100).
    05  content-type         PIC X(1024).
    05  content-len          PIC S9(04).
    05  date-local           PIC X(50).
    05  date-gmt             PIC X(50).
    05  document-name        PIC X(100).
    05  document-root        PIC X(100).
    05  document-uri         PIC X(100).
    05  forwarded            PIC X(1024).
    05  frm                  PIC X(1024).
    05  gateway-interface    PIC X(1024).
    05  http-accept          PIC X(1024).
    05  http-accept-charset  PIC X(1024).
    05  http-accept-encoding PIC X(1024).
    05  http-accept-language PIC X(1024).
    05  http-cache-control   PIC X(1024).
    05  http-connection      PIC X(1024).
    05  http-cookie          PIC X(8192).
    05  http-form            PIC X(8192).
    05  http-host            PIC X(100).
    05  http-referrer        PIC X(1024).
    05  http-ua-color        PIC X(50).
    05  http-ua-cpu          PIC X(50).
    05  http-ua-os           PIC X(50).
    05  http-ua-pixels       PIC x(50).
    05  http-user-agent      PIC X(1024).
    05  http-x-forwarded-for PIC X(1024).
    05  instance-id          PIC X(1024).
    05  last-modified        PIC X(50).
    05  page-count           PIC X(10).
    05  path                 PIC X(4096).
    05  path-info            PIC X(1024).
    05  path-translated      PIC X(1024).
    05  query-string         PIC X(1024).
    05  query-string-unescaped PIC X(1024).
    05  remote-addr          PIC X(1024).
    05  remote-host          PIC X(1024).
    05  remote-ident         PIC X(1024).
    05  remote-port          PIC X(100).
    05  remote-user          PIC X(100).
    05  script-filename      PIC X(1024).
    05  script-name          PIC X(1024).
    05  script-uri           PIC X(1024).
    05  script-url           PIC X(1024).
    05  server-admin         PIC X(1024).
    05  server-addr          PIC X(1024).
    05  server-name          PIC X(1024).
    05  server-port          PIC X(100).
    05  server-protocol      PIC X(100).
    05  server-signature     PIC X(1024).
    05  server-software      PIC X(1024).
    05  total-hits           PIC X(100).
    05  tz                   PIC X(100).
    05  unique-id            PIC X(100).
    05  user-name            PIC X(100).
    05  visp-remote-addr     PIC X(1024).
    05  visp-user            PIC X(1024).
    05  visp-domain          PIC X(1024).
    05  headers OCCURS 10 TIMES.
    10  header-key      PIC X(80) VALUE SPACES.
    10  header-value    PIC X(1024) VALUE SPACES.
    05  headers-count       PIC S9(04).
    05  parameters OCCURS 10 TIMES.
    10  parameter-key   PIC X(80) VALUE SPACES.
    10  parameter-value PIC X(1024) VALUE SPACES.
    05  parameters-count    PIC S9(04).
