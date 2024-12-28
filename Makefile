.PHONY: all

COBC_FLAGS=-Wall

COBSHA3_FILES=$(wildcard lib/cobsha3/*.cob)

all: out/listbooks out/adduser out/router

init:
	@mkdir -p generated
	@mkdir -p out

out/listbooks: init listbooks.cbl
	esqlOC -o generated/listbooks.cob listbooks.cbl
	cobc $(COBC_FLAGS) -x generated/listbooks.cob -o out/listbooks -locsql

out/cobsha3.so: init $(COBSHA3_FILES)
	cobc -free -o out/cobsha3 $(COBC_FLAGS) -b $(COBSHA3_FILES)

out/adduser: init out/cobsha3.so adduser.cbl
	esqlOC -o generated/adduser.cob adduser.cbl
	cobc $(COBC_FLAGS) -x generated/adduser.cob -o out/adduser -Lout/ -locsql

out/router: init router.cbl
	cobc $(COBC_FLAGS) -x router.cbl -o out/router

run-listbooks: out/listbooks
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so:./out/cobsha3.so ; ./out/listbooks

run-adduser: out/adduser
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so:./out/cobsha3.so ; ./out/adduser

clean:
	rm -rf generated/ out/

