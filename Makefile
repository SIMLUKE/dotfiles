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
			man-db	\
			fzf	\
			cron	\
			meson	\
			cargo	\
			scdoc	\
			libxkbcommon	\
			neofetch	\
			nerd-fonts	\
			pulseaudio	\
			pulseaudio-bluetooth	\
			blueman	\
			pavucontrol	\
			inotify-tools	\
			swappy	\
			grim	\
			xclip	\
			slurp	\
			xdg-user-dirs	\
			brightnessctl	\

YAY_PACKAGES	=	opera	\
			deezer	\
			ttf-font-logos	\
			sddm-sugar-dark	\

all: _zsh _emacs _swaylock _wofi _hyprland _scripts _waybar _wpaperd _kitty _sddm

_zsh:
	$(STOW) --target=$(TARGET) --restow zsh

_zsh_plugins:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

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

_waybar:
	$(STOW) --target=$(TARGET) --restow waybar

_wpaperd:
	$(STOW) --target=$(TARGET) --restow wp_manager

_kitty:
	$(STOW) --target=$(TARGET) --restow kitty

_sddm:
	sudo cp sddm/sddm.conf /etc/
	sudo cp sddm/theme.conf /usr/share/sddm/themes/sugar-dark/
	sudo cp sddm/Background.png /usr/share/sddm/themes/sugar-dark/
	sudo cp sddm/Xsetup /usr/share/sddm/scripts/Xsetup

wallpapers_install:
	git clone https://github.com/danyspin97/wpaperd
	cd ./wpaperd ; cargo build --release ; cargo install --path="./daemon" && cargo install --path="./cli"

yay_install:
	git clone https://github.com/Jguer/yay.git
	cd yay ; makepkg -i

dependencies:
	sudo pacman -Sy $(PACKAGES)

yay_dependencies:
	yay -Sy $(YAY_PACKAGES)

sys_calls:
	sudo systemctl enable bluetooth
	sudo systemctl start bluetooth
