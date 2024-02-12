# shellcheck disable=SC2148
# fzf ctrl-t for selected files and directorios
# export FZF_CTRL_T_COMMAND='rg --files --hidden --follow'
export FZF_CTRL_T_OPTS='--preview="batcat -n --color=always {}" --bind="ctrl-/:toggle-preview" --preview-window=:hidden'
alias fzfi='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}" | fzf'
