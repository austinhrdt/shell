#!/bin/zsh

alias ls='ls -alh'
alias brewski='brew update && brew upgrade && brew cleanup; brew doctor'
alias code='code-insiders'
alias work="cd ~/working"
alias pip="pip3"
alias python="python3"
alias gs="git status"
alias gc="git add . && git commit -m"
alias gotv="go mod tidy && go mod vendor"
alias gogu="go get -u ./..."
alias awslocal="aws --profile localstack --endpoint-url=http://localhost:4566"
