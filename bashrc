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

kpush(){
    APP=$(basename $PWD)
    FULL_APP=$(kubectl get deployments.apps $APP -o json | jq -r '.spec.template.spec.containers[0].image')
    SVC_NAME=$(echo $FULL_APP | awk -F: '{print $1}')
    TAG=$(echo $FULL_APP | awk -F: '{print $2}')
    NEXT=$(echo  ${TAG}+0.1 | bc)
    KUBE_FOLDER=../../deploy/kubernetes
    export NEXT_SVC=${SVC_NAME}:${NEXT}
    docker buildx build . --tag $SVC_NAME:$NEXT --push --platform linux/amd64,linux/arm64
    yq e -i 'select(document_index == 0) |= .spec.template.spec.containers[0].image=env(NEXT_SVC)  ' $KUBE_FOLDER/$APP.yaml
    kubectl apply -f $KUBE_FOLDER/$APP.yaml
}

PS1="%F{green}%1~ %F{blue} $PS1 $(kube_ps1)"
