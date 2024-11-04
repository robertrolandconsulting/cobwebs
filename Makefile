.PHONY: all cobsha3 run

COBC_FLAGS=-Wall -O

all: listbooks adduser

listbooks: listbooks.cbl
	esqlOC listbooks.cbl
	cobc $(COBC_FLAGS) -x listbooks.cob -locsql

cobsha3: 
	cobc -free -o cobsha3 $(COBC_FLAGS) -b $(shell find lib/cobsha3/*.cob)

adduser: cobsha3 adduser.cbl
	esqlOC adduser.cbl
	cobc $(COBC_FLAGS) -x adduser.cob -locsql

run-listbooks: listbooks
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so:./cobsha3.so ; ./listbooks

run-adduser: adduser
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so:./cobsha3.so ; ./adduser

clean:
	rm -f *.cob listbooks adduser cobsha3.so

