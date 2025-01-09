COBC_FLAGS=-Wall -I../copybooks/ -fdebugging-line

all: ../out/listbooks ../out/adduser ../out/cobwebs.fcgi

init:
	@mkdir -p ../generated
	@mkdir -p ../out

../out/listbooks: init listbooks.cbl
	esqlOC -o ../generated/listbooks.cob listbooks.cbl
	cobc $(COBC_FLAGS) -x ../generated/listbooks.cob -o ../out/listbooks -locsql

../out/adduser: init adduser.cbl
	esqlOC -o ../generated/adduser.cob adduser.cbl
	cobc $(COBC_FLAGS) -x ../generated/adduser.cob -o ../out/adduser -L../out/ -locsql

../out/cobwebs.fcgi: init cobwebs.cbl router.cbl utils.cbl
	cobc $(COBC_FLAGS) -o ../out/cobwebs.fcgi -x cobwebs.cbl fcgi.cbl router.cbl utils.cbl -A '-include fcgi_config.h' -A '-include fcgi_stdio.h' -lfcgi

clean:
	rm -rf ../generated/ ../out/

.PHONY: all init clean
