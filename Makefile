.PHONY: all

COBC_FLAGS=-Wall

COBSHA3_FILES=$(wildcard lib/cobsha3/*.cob)

all: listbooks adduser router

listbooks: listbooks.cbl
	esqlOC listbooks.cbl
	cobc $(COBC_FLAGS) -x listbooks.cob -locsql

cobsha3.so: $(COBSHA3_FILES)
	cobc -free -o cobsha3 $(COBC_FLAGS) -b $(COBSHA3_FILES)

adduser: cobsha3.so adduser.cbl
	esqlOC adduser.cbl
	cobc $(COBC_FLAGS) -x adduser.cob -locsql

router: router.cbl
	cobc $(COBC_FLAGS) -x router.cbl

run-listbooks: listbooks
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so:./cobsha3.so ; ./listbooks

run-adduser: adduser
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so:./cobsha3.so ; ./adduser

clean:
	rm -f *.cob cobsha3.so listbooks router adduser

