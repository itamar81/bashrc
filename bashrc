PS1=""
export PATH="${PATH}:${HOME}/.krew/bin"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias watch='watch '
alias k=kubectl
autoload -Uz compinit
compinit
source <(kubectl krew completion zsh)
source <(kubectl completion zsh)

gitp(){
    git add .
    COMMIT_MSG="fix"
    if [ "$#" -gt 0 ]
    then
        COMMIT_MSG="$@"
    fi
    git commit -m "$COMMIT_MSG"
    git push
}

PS1="%F{green}%1~ %F{blue} $PS1 $(kube_ps1)"
