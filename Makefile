.PHONY: all

all: listbooks

listbooks: listbooks.cbl
	esqlOC listbooks.cbl
	cobc -x listbooks.cob -locsql

run: listbooks
	export COB_PRE_LOAD=/usr/local/lib/libocsql.so ; ./listbooks

clean:
	rm -f *.cob listbooks
