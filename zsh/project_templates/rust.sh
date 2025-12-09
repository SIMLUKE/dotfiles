alias cb='cargo build'
alias cbr='cargo build --release'
alias cr='cargo run'
alias crr='cargo run --release'
alias ct='cargo test'
alias ctv='cargo test -- --nocapture'
alias cc='cargo check'
alias ccl='cargo clippy'
alias cf='cargo fmt'
alias cclean='cargo clean'
alias cdoc='cargo doc --open'

alias cw='cargo watch -x run'
alias cwt='cargo watch -x test'
alias cwc='cargo watch -x check'

alias cbench='cargo bench'

alias cup='cargo update'
alias ctree='cargo tree'

setup() {
    echo "Setting up Rust project..."
    cargo build
    echo "✓ Rust project built"
}

run() {
    cargo run -- "$@"
}

echo "Rust project environment loaded"
