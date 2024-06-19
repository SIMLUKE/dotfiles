STOW	?=	stow --dotfiles

HOME	?=	$$HOME

DOT_CONF	?=	$$HOME/.config/

PACKAGES	=	cmake	\
			emacs	\
			zsh	\
			thunar	\
			stow	\
			man-db	\
			fzf	\
			meson	\
			cargo	\
			scdoc	\
			libxkbcommon	\
			neofetch	\
			nerd-fonts	\
			pipewire	\
			pipewire-audio	\
			pipewire-jack	\
			pipewire-pulse	\
			blueman	\
			bluez	\
			pavucontrol	\
			inotify-tools	\
			swappy	\
			grim	\
			xclip	\
			slurp	\
			xdg-user-dirs	\
			brightnessctl	\
			hyprpaper	\
			hypridle	\
			waybar	\
			mako	\

YAY_PACKAGES	=	opera	\
			swaylock-effects	\
			spicetify-cli	\
			spotify	\
			swww	\
			ttf-font-logos	\
			sddm-sugar-dark	\

all: _zsh _emacs _swaylock _wofi _hyprland _scripts _waybar _kitty _my_dwall _spicetify _mako

_zsh:
	$(STOW) --target=$(HOME) --restow zsh

_zsh_plugins:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

_emacs:
	$(STOW) --target=$(HOME) --restow emacs

_swaylock:
	$(STOW) --target=$(DOT_CONF) --restow swaylock

_wofi:
	$(STOW) --target=$(DOT_CONF) --restow wofi

_hyprland:
	$(STOW) --target=$(DOT_CONF) --restow hyprland

_scripts:
	$(STOW) --target=$(HOME) --restow scripts

_waybar:
	$(STOW) --target=$(DOT_CONF) --restow waybar

_wpaperd:
	$(STOW) --target=$(DOT_CONF) --restow wp_manager

_kitty:
	$(STOW) --target=$(DOT_CONF) --restow kitty

_my_dwall:
	$(STOW) --target=$(DOT_CONF) --restow my_dwall

_spicetify:
	echo "pls fix spotify"

_mako:
	$(STOW) --target=$(DOT_CONF) --restow mako

_sddm:
	sudo cp sddm/sddm.conf /etc/
	sudo cp sddm/theme.conf /usr/share/sddm/themes/sugar-dark/
	sudo cp sddm/Background.png /usr/share/sddm/themes/sugar-dark/
	sudo cp sddm/Xsetup /usr/share/sddm/scripts/Xsetup

wpaperd_install:
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
