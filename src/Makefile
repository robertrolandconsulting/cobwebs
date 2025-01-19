COBC_FLAGS=-Wall -I../copybooks/

all: ../out/cobwebs.fcgi

init:
	@mkdir -p ../generated
	@mkdir -p ../out

../out/cobwebs.fcgi: init cobwebs.cbl router.cbl utils.cbl
	cobc $(COBC_FLAGS) -o ../out/cobwebs.fcgi -x cobwebs.cbl fcgi.cbl router.cbl utils.cbl -A '-include fcgi_config.h' -A '-include fcgiapp.h' -lfcgi

clean:
	rm -rf ../generated/ ../out/

.PHONY: all init clean
