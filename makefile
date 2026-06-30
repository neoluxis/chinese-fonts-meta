SHELL := /bin/bash

META_DIRS := $(sort $(dir $(wildcard *-meta/PKGBUILD)))
META_NAMES := $(patsubst %/,%,$(META_DIRS))

.PHONY: list install install-all all clean $(META_NAMES)

list:
	@printf '%s\n' $(META_NAMES)

install:
	@if [ -z "$(PKG)" ]; then \
		echo "Usage: make install PKG=chinese-fonts-meta"; \
		echo "Available:"; \
		printf '  %s\n' $(META_NAMES); \
		exit 1; \
	fi
	@if [ ! -f "$(PKG)/PKGBUILD" ]; then \
		echo "No such meta package: $(PKG)"; \
		exit 1; \
	fi
	cd "$(PKG)" && makepkg -f --syncdeps --install

install-all all:
	@for pkg in $(META_NAMES); do \
		echo "==> Installing $$pkg"; \
		(cd "$$pkg" && makepkg -f --syncdeps --install) || exit $$?; \
	done

clean:
	@for pkg in $(META_NAMES); do \
		echo "==> Cleaning $$pkg"; \
		(cd "$$pkg" && rm -rf pkg src *.pkg.tar.* *.log); \
	done

$(META_NAMES):
	cd "$@" && makepkg -f --syncdeps --install