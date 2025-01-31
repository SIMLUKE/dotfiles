STOW	?=	stow --dotfiles

HOME	?=	$$HOME

DOT_CONF	?=	$$HOME/.config/

PACKAGES	=	cmake	\
			emacs	\
			neovim	\
			zsh	\
			thunar	\
			stow	\
			man-db	\
			fzf	\
			scdoc	\
			libxkbcommon	\
			neofetch	\
			nerd-fonts	\
			pipewire	\
			pipewire-audio	\
			pipewire-jack	\
			pipewire-pulse	\
			wireplumber	\
			blueman	\
			bluez	\
			flatpak	\
			inotify-tools	\
			swappy	\
			grim	\
			wl-clipboard	\
			slurp	\
			xdg-user-dirs	\
			brightnessctl	\
			hypridle	\
			waybar	\
			mako	\
			feh	\
			mpv	\
			rofi-wayland	\
			ranger	\

YAY_PACKAGES	=	firefox	\
			swaylock-effects	\
			deezer	\
			swww	\
			wf-recorder	\
			ttf-font-logos	\
			nerd-fonts	\
			rofi-nerdy-git	\
			rofi-bluetooth-git	\
			rofi-calc-git	\
			webapp-manager	\

FLATPAK_PACKAGES	=	pwvucontrol	\

NPM_PACKAGES	=	bashls	\

all: _zsh _zsh_custom _emacs _swaylock _wofi _mimeapps _rofi _hyprland _scripts _waybar _kitty _my_dwall _spicetify _mako _nyxt _neovim _colors _clang_conf

_zsh:
	$(STOW) --target=$(HOME) --restow zsh

_zsh_custom:
	$(STOW) --target=$(HOME)/.oh-my-zsh --restow oh_my_zsh

_zsh_plugins:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

_emacs:
	rm ~/.emacs.default/own_conf/conf.el
	$(STOW) --target=$(HOME) --restow emacs

_swaylock:
	$(STOW) --target=$(DOT_CONF) --restow swaylock

_wofi:
	$(STOW) --target=$(DOT_CONF) --restow wofi

_rofi:
	$(STOW) --target=$(DOT_CONF) --restow rofi

_hyprland:
	$(STOW) --target=$(DOT_CONF) --restow hyprland

_scripts:
	$(STOW) --target=$(HOME) --restow scripts

_clang_conf:
	$(STOW) --target=$(HOME) --restow clang

_mimeapps:
	$(STOW) --target=$(DOT_CONF) --restow mimeapps

_waybar:
	$(STOW) --target=$(DOT_CONF) --restow waybar

_wpaperd:
	$(STOW) --target=$(DOT_CONF) --restow wp_manager

_kitty:
	$(STOW) --target=$(DOT_CONF) --restow kitty

_nyxt:
	$(STOW) --target=$(DOT_CONF) --restow nyxt

_neovim:
	$(STOW) --target=$(DOT_CONF) --restow neovim

_my_dwall:
	$(STOW) --target=$(DOT_CONF) --restow my_dwall

_spicetify:
	echo "pls fix spotify"

_mako:
	$(STOW) --target=$(DOT_CONF) --restow mako

_colors:
	$(STOW) --target=$(DOT_CONF) --restow colors

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

flatpak_dependencies:
	flatpak install $(FLATPAK_PACKAGES)

npm_dependencies:
	sudo npm -g i $(NPM_PACKAGES)

sys_calls:
	sudo systemctl enable bluetooth
	sudo systemctl start bluetooth
