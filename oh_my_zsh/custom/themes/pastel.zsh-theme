return_code="%{$fg[red]%}%(?..%? <-)%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""


PROMPT='%{$fg[magenta]%}%m%{$fg[red]%}%#%{$fg[blue]%}%n%{$reset_color%}-%~ $(git_prompt_info)
> '
RPROMPT='${return_code}'
