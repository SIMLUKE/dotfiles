##
## Just a Makefile to reconfigure everything easily
##

STOW	?=	stow

TARGET	?=	$$HOME

PACKAGES	=	cmake	\
			emacs	\
			swaylock-effects	\

all: _zsh _emacs swaylock _wofi

_zsh:
	$(STOW) --target=$(TARGET) --restow zsh
_emacs:
	$(STOW) --target=$(TARGET) --restow emacs
_swaylock:
	$(STOW) --target=$(TARGET) --restow swaylock
_wofi:
	$(STOW) --target=$(TARGET) --restow wofi
_hyprland:
	$(STOW) --target=$(TARGET) --restow hyprland
_scripts:
	$(STOW) --target=$(TARGET) --restow scripts
dependencies:w
	sudo pacman -S $(PACKAGES)
