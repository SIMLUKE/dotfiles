##
## Just a Makefile to reconfigure everything easily
##

STOW	?=	stow

TARGET	?=	$$HOME

PACKAGES	=	emacs	\
			swaylock-effects	\

all: _zsh _emacs swaylock

_zsh:
	$(STOW) --target=$(TARGET) --restow zsh
_emacs:
	$(STOW) --target=$(TARGET) --restow emacs
_swaylock:
	$(STOW) --target=$(TARGET) --restow swaylock
_wofi:
	$(STOW) --target=$(TARGET) --restow wofi
dependencies:
	sudo pacman -S $(PACKAGES)
