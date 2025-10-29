# Source environment configuration
for file in ~/.config/env.d/*.sh; do
    [ -r "$file" ] && source "$file"
done

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# History configuration
HIST_STAMPS="mm/dd/yyyy"
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST

# Cool themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="jonathan"
#ZSH_THEME="kphoen"

if [[ -n "$INSIDE_EMACS" ]]; then
    export ZSH_THEME="kphoen"
    while [[ $(pwd) = *'src'* || $(pwd) = *'include'* || $(pwd) = *'libs'* ]]; do
        cd ../
    done
else
    export ZSH_THEME="pastel"
fi

 #Pimp tty colors
 if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0232323" #black
    echo -en "\e]P82B2B2B" #darkgrey
    echo -en "\e]P1D75F5F" #darkred
    echo -en "\e]P9E33636" #red
    echo -en "\e]P287AF5F" #darkgreen
    echo -en "\e]PA98E34D" #green
    echo -en "\e]P3D7AF87" #brown
    echo -en "\e]PBFFD75F" #yellow
    echo -en "\e]P48787AF" #darkblue
    echo -en "\e]PC7373C9" #blue
    echo -en "\e]P5BD53A5" #darkmagenta
    echo -en "\e]PDD633B2" #magenta
    echo -en "\e]P65FAFAF" #darkcyan
    echo -en "\e]PE44C9C9" #cyan
    echo -en "\e]P7E5E5E5" #lightgrey
    echo -en "\e]PFFFFFFF" #white
    clear #for background artifacting
 fi


# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# SSH agent (avoid multiple instances)
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" &> /dev/null
fi
ssh-add ~/.ssh/id_stud &> /dev/null 2>&1


# Gui use of emacs
ne() {
    emacsclient -c -s tiny -a "" "$1" &
    disown
}
alias VSgui='emacsclient -c'

# TTY use of emacs
alias nee='emacsclient -nw -s tiny'
alias VSemacs='emacsclient -nw'

# Aliases
get_core() {
    pat="/var/lib/systemd/coredump/"
    core=$(ls -t $pat | fzf)
    conc=$pat$core
    cp $conc ./
    unzstd $core
    rm $core
}

update_zsh() {
    rm ~/.oh-my-zsh/custom
    omz update
    rm ~/.oh-my-zsh/custom
    make -C ~/dotfiles
    source ~/.zshrc
}

ignoreFile() {
    echo "$1" >> ./.gitignore
}

# My remplacements
cd() {builtin cd "$@" &&
          ls .
}

zl() {
    z "$@" && ls .
}

alias cp='cp -r'
#alias cat='bat'
alias sl='ls'

# Faliases
alias fman='compgen -c | fzf | xargs man'
alias fhistory='history | cut -c 8- | fzf'

# Aliases
alias pip='./.venv/bin/pip'
alias py_create_venv='python -m venv .venv'
alias gdba='gdb --args'
alias dot='cd ~/Dotfiles'
alias mkdb='make debug -s'
alias mkBIGdb='make debug_w_libs debug -s'
alias cacabomb='v=0;while [[ $v != "5" ]];do cacademo &;v=$((value+1));done'
alias rotate_normal='wlr-randr --output eDP-1 --transform normal'
alias rotate_up='wlr-randr --output eDP-1 --transform 180'
alias remove_package='yay -Qe | fzf -m | cut -d " " -f 1 | xargs yay -Rns --noconfirm'
wipe_docker() {
    docker-compose down
    docker system prune -a
}
alias cleanAtess='prettier --write . ; ruff check --fix ; ruff format'
alias spellfr='hunspell -d fr_FR'
alias spellen='hunspell'
alias vencord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'
alias nw='kitty . &> /dev/null &'
alias compare='nvim -d /tmp/got.txt /tmp/expected.txt'
alias nv='nvim'
alias astekmode='eval "$(ssh-agent -s)" ; ssh-add ~/.ssh/id_astek'
alias o='xdg-open'
nz() {
    z $0 ; nv .
}
eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/lukeskieur/programs/google-cloud-sdk/path.zsh.inc' ]; then . '/home/lukeskieur/programs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/lukeskieur/programs/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/lukeskieur/programs/google-cloud-sdk/completion.zsh.inc'; fi



[ -f "/home/lukeskieur/.ghcup/env" ] && . "/home/lukeskieur/.ghcup/env" # ghcup-env

alias emacs='emacs -nw'
