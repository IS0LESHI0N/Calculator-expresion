CC = clang
LAB_OPTS = -I./src src/lib.c
C_OPTS = $(MAC_OPTS) -std=gnu11  -gdwarf-4 -lm  -Wall -Wextra -Werror -Wformat-security -Wfloat-equal -Wshadow -Wconversion -Wlogical-not-parentheses -Wnull-dereference -Wno-unused-variable -Werror=vla $(LAB_OPTS)
DOCG = doxygen
DOC = Doxyfile
V_FLAGS = --tool=memcheck --leak-check=full --show-reachable=yes \
	--undef-value-errors=yes --track-origins=no --child-silent-after-fork=no \
	--trace-children=no --error-exitcode=1
V_LAGS = valgrind

clean:
	rm -rf dist

clean1:
	rm -rf ./dist/html
	rm -rf ./dist/latex 
prep:
	mkdir dist
compile: main.bin

main.bin: src/main.c
	$(CC) $(C_OPTS) $< -o ./dist/$@
	

run: clean prep compile
	./dist/main.bin
check:
	clang-format --verbose -dry-run --Werror src/*
	clang-tidy src/*.c  -checks=-readability-uppercase-literal-suffix,-readability-magic-numbers,-clang-analyzer-deadcode.DeadStores,-clang-analyzer-security.insecureAPI.rand
	rm -rf src/*.dump

all: clean prep compile main.bin test.bin test
	./dist/main.bin
	LLVM_PROFILE_FILE="dist/test.profraw" ./dist/test.bin
	llvm-profdata merge -sparse dist/test.profraw -o dist/test.profdata
	llvm-cov report dist/test.bin -instr-profile=dist/test.profdata src/*.c
	llvm-cov show dist/test.bin -instr-profile=dist/test.profdata src/*.c --format html > dist/coverage.html

	
Doxygen:
	$(DOCG) $(DOC)
	
all1: clean1 Doxygen

test_all: clean prep test.bin test

test.bin:src/test.c
	 $(CC) $(C_OPTS) $< -fprofile-instr-generate -fcoverage-mapping -lsubunit  -o ./dist/$@ -lcheck 
test: dist
	LLVM_PROFILE_FILE="dist/test.profraw" ./dist/test.bin
	llvm-profdata merge -sparse dist/test.profraw -o dist/test.profdata
	llvm-cov report dist/test.bin -instr-profile=dist/test.profdata src/*.c
	llvm-cov show dist/test.bin -instr-profile=dist/test.profdata src/*.c --format html > dist/coverage.html



leak-check_main1:clean prep main.bin
	$(V_LAGS) $(V_FLAGS)  --log-file=dist/valgrind_main.log  dist/main.bin
leak-check_main2: 
	$(V_LAGS) $(V_FLAGS) --xml-file=dist/valgrind_main.xml  --xml=yes dist/main.bin 

leak-check_test2:
	$(V_LAGS)  $(V_FLAGS) --xml-file=dist/valgrind_test.xml  --xml=yes dist/test.bin
leak-check_test1:clean prep test.bin
	$(V_LAGS)  $(V_FLAGS)  --log-file=dist/valgrind_test.log  dist/test.bin
