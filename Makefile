##
## Just a Makefile to reconfigure everything easily
##

STOW	?=	stow

TARGET	?=	$$HOME

PACKAGES	=	cmake	\
			emacs	\
			zsh	\
			thunar	\
			stow	\

all: _zsh _emacs _swaylock _wofi _hyprland _scripts

_zsh:
	$(STOW) --target=$(TARGET) --restow zsh
_zsh_plugins:
	##sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	##git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zshautosuggestions.git ~/.oh-my-zsh/custom/plugins/zshautosuggestions

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
dependencies:
	sudo pacman -S $(PACKAGES)
