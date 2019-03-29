LIBS = 
LIB_DIR =
FLAGS = -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: fast slow

fast: ./lib/fast.c ./lib/aps.c
	gcc $(FLAGS) $(LIB_DIR) -o ./lib/$@ $^ $(LIBS)

slow: ./lib/slow.c ./lib/aps.c
	gcc $(FLAGS) $(LIB_DIR) -o ./lib/$@ $^ $(LIBS)

clean:
	rm -f *.o *~ ./lib/fast ./lib/slow

start:
	./lib/script.sh
