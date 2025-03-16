COBC_FLAGS=-I../copybooks/ -ffree-form

all: ../out/cobwebs.fcgi

init:
	@mkdir -p ../generated
	@mkdir -p ../out

../out/cobwebs.fcgi: init cobwebs.cbl router.cbl utils.cbl
	gcobol $(COBC_FLAGS) -o ../out/cobwebs.fcgi cobwebs.cbl fcgi.cbl router.cbl utils.cbl -A '-include fcgi_config.h' -A '-include fcgiapp.h' -lfcgi

clean:
	rm -rf ../generated/ ../out/

.PHONY: all init clean
