SHELL := /bin/bash

META_DIRS := $(sort $(dir $(wildcard *-meta/PKGBUILD)))
META_NAMES := $(patsubst %/,%,$(META_DIRS))
AUR_HELPER ?= paru

.PHONY: list install install-all all clean $(META_NAMES)

list:
	@printf '%s\n' $(META_NAMES)

install:
	@if [ -z "$(PKG)" ]; then \
		echo "Usage: make install PKG=chinese-fonts-meta"; \
		exit 1; \
	fi
	cd "$(PKG)" && $(AUR_HELPER) -Bi --noconfirm .

install-all all:
	@for pkg in $(META_NAMES); do \
		echo "==> Installing $$pkg"; \
		(cd "$$pkg" && $(AUR_HELPER) -Bi --noconfirm .) || exit $$?; \
	done

clean:
	@for pkg in $(META_NAMES); do \
		echo "==> Cleaning $$pkg"; \
		(cd "$$pkg" && rm -rf pkg src *.pkg.tar.* *.log); \
	done

uninstall:
	@if [ -z "$(PKG)" ]; then \
		echo "Usage: make uninstall PKG=<meta-package>"; \
		exit 1; \
	fi
	@pkgname=$$(source "$(PKG)/PKGBUILD"; echo $$pkgname); \
	echo "==> Removing $$pkgname"; \
	sudo pacman -Rns --noconfirm $$pkgname

uninstall-all:
	@for pkg in $(META_NAMES); do \
		pkgname=$$(source "$$pkg/PKGBUILD"; echo $$pkgname); \
		echo "==> Removing $$pkgname"; \
		sudo pacman -Rns --noconfirm $$pkgname || true; \
	done

$(META_NAMES):
	cd "$@" && $(AUR_HELPER) -Bi .
