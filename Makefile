all:
	@make -C lib all
	@make -C src all

clean:
	@make -C lib clean
	@make -C src clean

.PHONY: all clean
