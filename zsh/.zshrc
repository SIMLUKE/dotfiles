# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:"$HOME/my_scripts/"

# Modifier for bug fixes
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# export TERM=xterm-24bits
QT_QPA_PLATFORM=xcb
HIST_STAMPS="mm/dd/yyyy"

# Installed paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.cargo/bin/"
export PATH="$PATH:/home/lukeskieur/.local/bin"
export PATH="$PATH:/home/lukeskieur/Documents/poc/BruteForce/"

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
    export ZSH_THEME="kphoen"
fi

# Pimp tty colors
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

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Preference
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='emacs --with-profile tiny'
 else
   export EDITOR='emacs --with-profile tiny'
 fi
 export BROWSER=firefox

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

# My remplacements
cd() {builtin cd "$@" &&
          ls .
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
alias cacabomb='v=0;while [[ $v != "10" ]];do cacademo &;v=$((value+1));done'
alias rotate_normal='wlr-randr --output eDP-1 --transform normal'
alias rotate_up='wlr-randr --output eDP-1 --transform 180'
alias remove_package='pacman -Qe | fzf -m | cut -d " " -f 1 | xargs sudo pacman -Rns --noconfirm'
wipe_docker() {
    docker-compose down
    docker system prune -a
}
alias cleanAtess='prettier --write . ; ruff check --fix ; ruff format'
# docker pull ghcr.io/gitleaks/gitleaks:latest
source /home/lukeskieur/Documents/poc/BruteForce/autocompletion/zsh/_bruteforce
