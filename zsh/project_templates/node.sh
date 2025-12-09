alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nun='npm uninstall'
alias nup='npm update'

alias dev='npm run dev'
alias build='npm run build'
alias start='npm start'
alias test='npm test'
alias lint='npm run lint'
alias format='npm run format'

alias clean='rm -rf node_modules package-lock.json && npm install'
alias clean-cache='npm cache clean --force'

alias outdated='npm outdated'
alias audit='npm audit'
alias audit-fix='npm audit fix'

nrun() {
    npm run "$@"
}

echo "Node.js project environment loaded"
