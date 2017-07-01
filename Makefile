all: install

install: build
	cp -f bin/crystalmon /usr/local/bin

build: clear
	crystal build --release -o bin/crystalmon src/crystalmon.cr 

clear:
	rm bin/crystalmon || true

test:
	crystal spec
