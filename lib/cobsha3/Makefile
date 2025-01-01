COBC_FLAGS=-Wall

SRC=$(wildcard *.cob)

all: ../../out/cobsha3.so

init:
	@mkdir -p ../../out

../../out/cobsha3.so: init $(SRC)
	cobc -free -o ../../out/cobsha3 $(COBC_FLAGS) -b $(SRC)

clean:
	rm -rf ../../out/cobsha3*

.PHONY: all init clean
