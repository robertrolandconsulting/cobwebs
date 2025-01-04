#include <fcgi_stdio.h>

int main( int argc, char *argv[] )
{
   while( FCGI_Accept() >= 0 ) {
      printf("sizeof FCGX_Stream = %d\n", sizeof(FCGX_Stream));
      printf("sizeof unsigned char * = %d\n", sizeof(unsigned char *));
      printf("sizeof int = %d\n", sizeof(int));
      printf("sizeof void (*fillBuffProc) (struct FCGX_Stream *stream) = %d\n", sizeof(void (*) (struct FCGX_Stream *stream)));
      printf("sizeof void (*emptyBuffProc) (struct FCGX_Stream *stream, int doClose) = %d\n", sizeof(void (*) (struct FCGX_Stream *stream, int doClose)));
      printf("sizeof void * = %d\n", sizeof(void*));

      printf( "Content-Type: text/plain\n\n" );
      printf( "Hello world in C\n" );
   }
   return 0;
}
