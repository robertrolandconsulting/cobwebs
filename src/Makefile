COBC_FLAGS=-Wall -I../copybooks/

all: ../out/listbooks ../out/adduser ../out/router

init:
	@mkdir -p ../generated
	@mkdir -p ../out

../out/listbooks: init listbooks.cbl
	esqlOC -o ../generated/listbooks.cob listbooks.cbl
	cobc $(COBC_FLAGS) -x ../generated/listbooks.cob -o ../out/listbooks -locsql

../out/adduser: init adduser.cbl
	esqlOC -o ../generated/adduser.cob adduser.cbl
	cobc $(COBC_FLAGS) -x ../generated/adduser.cob -o ../out/adduser -L../out/ -locsql

../out/router: init router.cbl utils.cbl
	cobc $(COBC_FLAGS) -o ../out/router -x router.cbl utils.cbl

clean:
	rm -rf ../generated/ ../out/

.PHONY: all init clean
