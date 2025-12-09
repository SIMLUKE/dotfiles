alias dev='npm run dev'
alias serve='python -m http.server 8000'
alias php-serve='php -S localhost:8000'

alias build='npm run build'
alias build-prod='npm run build -- --mode production'

alias test='npm test'
alias e2e='npm run test:e2e'

alias lint='npm run lint'
alias lint-fix='npm run lint -- --fix'
alias format='npm run format'

alias db-migrate='npm run migrate'
alias db-seed='npm run seed'
alias db-reset='npm run migrate:reset && npm run seed'

alias up='docker compose up'
alias upb='docker compose up --build'
alias down='docker compose down'
alias logs='docker compose logs -f'
alias cleanAtess='prettier --write . ; ruff check --fix ; ruff format'

echo "Web development environment loaded"
