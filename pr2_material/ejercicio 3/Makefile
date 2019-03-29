LIBS =
LIB_DIR =
FLAGS = -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: fast slow program program_t

fast: ./lib/fast.c ./lib/aps.c
	gcc $(FLAGS) $(LIB_DIR) -o ./lib/$@ $^ $(LIBS)

slow: ./lib/slow.c ./lib/aps.c
	gcc $(FLAGS) $(LIB_DIR) -o ./lib/$@ $^ $(LIBS)

program: ./lib/program.c ./lib/aps.c
	gcc $(FLAGS) $(LIB_DIR) -o ./lib/$@ $^ $(LIBS)

program_t: ./lib/program_t.c ./lib/aps.c
	gcc $(FLAGS) $(LIB_DIR) -o ./lib/$@ $^ $(LIBS)

clean:
	rm -f *.o *~ fast slow program program_t

start:
	./lib/script.sh
