##
## Just a Makefile to reconfigure everything easily
##

STOW ?= stow

TARGET ?= $$HOME

all: _zsh

_zsh:
	$(STOW) --target=$(TARGET) --restow zsh
