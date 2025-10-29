STOW	?=	stow --dotfiles

HOME	?=	$$HOME

DOT_CONF	?=	$$HOME/.config/

PACKAGES	=	cmake	\
			emacs	\
			neovim	\
			zsh	\
			zoxide	\
			thunar	\
			stow	\
			man-db	\
			fzf	\
			scdoc	\
			libxkbcommon	\
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
			swaync	\
			feh	\
			mpv	\
			rofi-wayland	\
			ranger	\
			hyprlock	\
			cliphist	\

YAY_PACKAGES	=	deezer	\
			swww	\
			wf-recorder	\
			zen-browser-bin	\
			ttf-font-logos	\
			rofi-nerdy-git	\
			rofi-bluetooth-git	\
			rofi-calc-git	\
			webapp-manager	\

FLATPAK_PACKAGES	=	pwvucontrol	\

NPM_PACKAGES	=	bashls	\

all: _xdg_dirs _zsh _zsh_custom _swaync _mimeapps _rofi _hyprland _scripts _waybar _kitty _my_dwall  _neovim _colors _clang_conf

_xdg_dirs:
	@echo "Creating XDG-compliant directories..."
	@mkdir -p $(HOME)/.local/state/zsh
	@mkdir -p $(HOME)/.local/state/less
	@mkdir -p $(HOME)/.local/share/cargo
	@mkdir -p $(HOME)/.local/share/rustup
	@mkdir -p $(HOME)/.local/share/go
	@mkdir -p $(HOME)/.config/npm
	@mkdir -p $(HOME)/.config/docker
	@mkdir -p $(HOME)/.config/python

_zsh:
	$(STOW) --target=$(HOME) --restow zsh

_zsh_custom:
	$(STOW) --target=$(HOME)/.oh-my-zsh --restow oh_my_zsh

_zsh_plugins:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.oh-my-zsh/custom/plugins/zsh-vi-mode

_emacs:
	rm ~/.emacs.default/own_conf/conf.el
	$(STOW) --target=$(HOME) --restow emacs

_swaync:
	$(STOW) --target=$(DOT_CONF) --restow swaync

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

_kitty:
	$(STOW) --target=$(DOT_CONF) --restow kitty

_neovim:
	$(STOW) --target=$(DOT_CONF) --restow neovim

_my_dwall:
	$(STOW) --target=$(DOT_CONF) --restow my_dwall

_spicetify:
	echo "pls fix spotify"

_colors:
	$(STOW) --target=$(DOT_CONF) --restow colors

yay_install:
	git clone https://aur.archlinux.org/yay.git
	cd yay ; makepkg -si

dependencies:
	sudo pacman -Sy $(PACKAGES)

yay_dependencies:
	yay -Sy $(YAY_PACKAGES)

flatpak_dependencies:
	flatpak install $(FLATPAK_PACKAGES)

npm_dependencies:
	sudo npm -g i $(NPM_PACKAGES)

.PHONY: backup
backup:
	@echo "Creating backup..."
	@tar -czf $(HOME)/dotfiles-backup-$$(date +%Y%m%d-%H%M%S).tar.gz .

.PHONY: check
check:
	@echo "Checking for broken symlinks in .config..."
	@find $(HOME)/.config -xtype l 2>/dev/null || echo "No broken symlinks found"

.PHONY: clean
clean:
	@echo "Removing dead symlinks..."
	@find $(HOME)/.config -xtype l -delete 2>/dev/null || echo "No broken symlinks to remove"

