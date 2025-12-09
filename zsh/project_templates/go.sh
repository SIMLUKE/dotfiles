alias gb='go build'
alias gr='go run .'
alias gt='go test ./...'
alias gtv='go test -v ./...'
alias gtr='go test -run'
alias gta='go test ./... -coverprofile=coverage.out && go tool cover -html=coverage.out'

alias gf='go fmt ./...'
alias gm='go mod tidy'
alias gmi='go mod init'
alias gmd='go mod download'
alias gv='go vet ./...'

alias gi='go install'
alias gg='go get'

alias bench='go test -bench=. -benchmem'

alias gclean='go clean -cache -testcache -modcache'

setup() {
    echo "Setting up Go project..."
    go mod download
    echo "✓ Go dependencies downloaded"
}

run() {
    go run . "$@"
}

echo "Go project environment loaded"
