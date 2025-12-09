return_code="%{$fg[red]%}%(?..%? <-)%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

project_template_prompt() {
    if [ -n "$PROJECT_TEMPLATES" ]; then
        echo "%{$fg[cyan]%}[$PROJECT_TEMPLATES]%{$reset_color%} "
    fi
}

PROMPT='%{$fg[magenta]%}%m%{$fg[red]%}%#%{$fg[blue]%}%n%{$reset_color%} %~ $(project_template_prompt)$(git_prompt_info)
> '
RPROMPT='${return_code}'
