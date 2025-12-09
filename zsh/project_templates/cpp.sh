alias cm='cmake'
alias cmb='cmake --build'
alias cmc='cmake --build . --target clean'
alias cmr='rm -rf build && cmake -B build && cmake --build build'
alias cmt='cmake --build . --target test'
alias cmcb='cmake -B build'
alias cmbb='cmake --build build'

cmake-debug() {
    cmake -B build -DCMAKE_BUILD_TYPE=Debug "$@"
}

cmake-release() {
    cmake -B build -DCMAKE_BUILD_TYPE=Release "$@"
}

cmake-quick() {
    cmake -B build && cmake --build build "$@"
}

alias gdb='gdb -q'
alias gdba='gdb -q --args'
alias valgrind='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'

alias cppcheck='cppcheck --enable=all --suppress=missingIncludeSystem'

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

if [ -d "build" ] && [ -f "CMakeLists.txt" ]; then
    if [ ! -f compile_commands.json ] && [ -f build/compile_commands.json ]; then
        ln -sf build/compile_commands.json .
    fi
fi

if [ ! -f compile_flags.txt ] && [ ! -f compile_commands.json ]; then
    echo "
-Iinclude
" >compile_flags.txt
fi

echo "C++ project environment loaded"
