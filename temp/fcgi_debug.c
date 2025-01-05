#include <stdio.h>
#include <unistd.h>

#include <fcgiapp.h>

int main(int argc, char** argv, char** envp)
{
    FCGX_Stream *in, *out, *err;
    FCGX_ParamArray env;
    int count = 0;

    fprintf(stderr, "before accept\n");
    fprintf(stderr, "in = %p\n", in);
    fprintf(stderr, "out = %p\n", out);
    fprintf(stderr, "err = %p\n", err);
    fprintf(stderr, "env = %p\n", env);

    while (FCGX_Accept(&in, &out, &err, &env) >= 0) {

        FCGX_FPrintF(out,
            "Content-type: text/html\r\n"
            "\r\n"
            "<title>FastCGI echo (fcgiapp version)</title>"
            "<h1>FastCGI echo (fcgiapp version)</h1>\n"
            "Request number %d,  Process ID: %d<p>\n",
            ++count, getpid());

        fprintf(stderr, "after accept\n");
        fprintf(stderr, "in = %p\n", in);
        fprintf(stderr, "out = %p\n", out);
        fprintf(stderr, "err = %p\n", err);
        fprintf(stderr, "env = %p\n", env);
    }

    return 0;
}
