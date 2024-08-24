all: botan jitter

.PHONY: \
	botan botan-check \
	jitter \
	clean

PREFIX?=${PWD}/local
BUILD?=${PWD}/build

PREFIX_INCLUDE=$(PREFIX)/include
PREFIX_LIB=$(PREFIX)/lib

clean:
	rm -f botan/Makefile
	rm -fr ${BUILD}
	rm -fr ${PREFIX}

jitter:
	cmake -S jitterentropy-library -B  ${BUILD}
	cmake --build ${BUILD}
	cmake --install ${BUILD} --prefix ${PREFIX}

botan/Makefile:
	cd botan && \
		./configure.py \
			--prefix=$(PREFIX) \
			--extra-cxxflags=-I$(PREFIX_INCLUDE) \
			--ldflags=-L$(PREFIX_LIB) \
			--without-documentation \
			--without-sphinx \
			--with-debug-info \
			--without-pdf \
			--without-rst2man \
			--without-doxygen \
			--without-boost \
			--without-openssl \
			--without-sqlite3

botan: botan/Makefile
	$(MAKE) -C botan libs
	$(MAKE) -C botan install

botan-check: botan/Makefile
	$(MAKE) -C botan check
