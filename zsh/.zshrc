# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:"$HOME/my_scripts/"

# Modifier for bug fixes
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# export TERM=xterm-24bits
QT_QPA_PLATFORM=xcb
HIST_STAMPS="mm/dd/yyyy"
export RANGER_LOAD_DEFAULT_RC="FALSE"

# Installed paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.cargo/bin/"
export PATH="$PATH:/home/lukeskieur/.local/bin"

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
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Preference
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi
 export BROWSER=zen-browser

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
alias gdba='gdb --args'
alias dot='cd ~/dotfiles'
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
