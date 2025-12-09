alias mk='make'
alias mkc='make clean'
alias mkr='make re'
alias mkd='make debug'
alias mkdb='make debug -s'
alias mkt='make tests_run'

alias gdb='gdb -q'
alias gdba='gdb -q --args'
alias valgrind='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'

alias cppcheck='cppcheck --enable=all --suppress=missingIncludeSystem'

compile() {
    gcc -Wall -Wextra -Werror "$@"
}

compile-debug() {
    gcc -Wall -Wextra -g3 "$@"
}

get_latest_core() {
    local core=$(ls -t core* 2>/dev/null | head -1)
    if [ -n "$core" ]; then
        echo "$core"
    else
        echo "No core dump found"
        return 1
    fi
}

debug_core() {
    local binary="$1"
    local core=$(get_latest_core)
    if [ -n "$binary" ] && [ -f "$core" ]; then
        gdb "$binary" "$core"
    else
        echo "Usage: debug_core <binary>"
    fi
}

if [ ! -f compile_flags.txt ]; then
    echo "
-Iinclude
" >compile_flags.txt
fi

echo "C project environment loaded"
