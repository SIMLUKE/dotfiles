alias venv='python -m venv .venv'
alias activate_venv='source .venv/bin/activate'
alias pip='./.venv/bin/pip'

alias run='python main.py'
alias test='pytest'
alias test-cov='pytest --cov=. --cov-report=html'
alias lint='ruff check .'
alias format='ruff format .'
alias clean='find . -type d -name "__pycache__" -exec rm -r {} + 2>/dev/null; find . -type f -name "*.pyc" -delete'

setup() {
    echo "Setting up Python project..."
    python -m venv .venv
    source .venv/bin/activate
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    fi
    echo "✓ Python environment ready"
}

echo "Python project environment loaded"
