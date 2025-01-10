01  http-request.
    05  request-uri                 PIC X(1024).
    05  request-method              PIC X(6).
    05  request-auth-type           PIC X(100).
    05  request-content-type        PIC X(1024).
    05  request-content-length      PIC S9(04).
    05  request-date-local          PIC X(50).
    05  request-date-gmt            PIC X(50).
    05  request-document-name       PIC X(100).
    05  request-document-root       PIC X(100).
    05  request-document-uri        PIC X(100).
    05  request-forwarded           PIC X(1024).
    05  request-from                PIC X(1024).
    05  request-gateway-interface   PIC X(1024).
    05  request-http-accept         PIC X(1024).
    05  request-http-accept-charset PIC X(1024).
    05  request-http-accept-encoding PIC X(1024).
    05  request-http-accept-language PIC X(1024).
    05  request-http-cache-control   PIC X(1024).
    05  request-http-connection      PIC X(1024).
    05  request-http-cookie          PIC X(8192).
    05  request-http-form            PIC X(8192).
    05  request-http-host            PIC X(100).
    05  request-http-referrer        PIC X(1024).
    05  request-http-ua-color        PIC X(50).
    05  request-http-ua-cpu          PIC X(50).
    05  request-http-ua-os           PIC X(50).
    05  request-http-ua-pixels       PIC x(50).
    05  request-http-user-agent      PIC X(1024).
    05  request-http-x-forwarded-for PIC X(1024).
    05  request-instance-id          PIC X(1024).
    05  request-last-modified        PIC X(50).
    05  request-page-count           PIC X(10).
    05  request-path                 PIC X(4096).
    05  request-path-info            PIC X(1024).
    05  request-path-translated      PIC X(1024).
    05  request-query-string         PIC X(1024).
    05  request-query-string-unescaped PIC X(1024).
    05  request-remote-addr          PIC X(1024).
    05  request-remote-host          PIC X(1024).
    05  request-remote-ident         PIC X(1024).
    05  request-remote-port          PIC X(100).
    05  request-remote-user          PIC X(100).
    05  request-script-filename      PIC X(1024).
    05  request-script-name          PIC X(1024).
    05  request-script-uri           PIC X(1024).
    05  request-script-url           PIC X(1024).
    05  request-server-admin         PIC X(1024).
    05  request-server-addr          PIC X(1024).
    05  request-server-name          PIC X(1024).
    05  request-server-port          PIC X(100).
    05  request-server-protocol      PIC X(100).
    05  request-server-signature     PIC X(1024).
    05  request-server-software      PIC X(1024).
    05  request-total-hits           PIC X(100).
    05  request-tz                   PIC X(100).
    05  request-unique-id            PIC X(100).
    05  request-user-name            PIC X(100).
    05  request-visp-remote-addr     PIC X(1024).
    05  request-visp-user            PIC X(1024).
    05  request-visp-domain          PIC X(1024).
    05  request-headers OCCURS 10 TIMES.
        10  request-header-key      PIC X(80) VALUE SPACES.
        10  request-header-value    PIC X(1024) VALUE SPACES.
    05  request-headers-count       PIC S9(04).
    05  request-parameters OCCURS 10 TIMES.
        10  request-parameter-key   PIC X(80) VALUE SPACES.
        10  request-parameter-value PIC X(1024) VALUE SPACES.
    05  request-parameters-count    PIC S9(04).
