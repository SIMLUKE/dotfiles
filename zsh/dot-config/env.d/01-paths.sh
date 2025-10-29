#!/bin/bash
# PATH configuration

# User scripts
export PATH="$HOME/my_scripts:$PATH"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Go
export PATH="$GOPATH/bin:$PATH"

# Cargo/Rust
export PATH="$CARGO_HOME/bin:$PATH"

# Additional paths
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
