.PHONY = all clean
all: clear_page_cache

clear_page_cache: clear_page_cache.c
	gcc -Wall -g -o $@ $<
	sudo chown root $@
	sudo chmod 4755 $@

clean:
	rm -f clear_page_cache
