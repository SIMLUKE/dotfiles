alias up='docker compose up'
alias upb='docker compose up --build'
alias down='docker compose down'
wipe_docker() {
    docker-compose down
    docker system prune -a
}
