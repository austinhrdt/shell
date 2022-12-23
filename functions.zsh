#!/bin/zsh

# --------------------------------------
#              FUNCTIONS
#      A bunch of useless functions
# --------------------------------------

# ------ ENVIRONMENT VARIABLES -------
# loads environment variables from a file
# loadenv [file]
load-environment() {
  export $(grep -v '^#' $1 | xargs)
}

# --------------- DOCKER ---------------
# stops all containers (except if your'e running from inside one), removes them, and deletes all images & volumes
cluster-fuck() {
  docker stop $(docker ps -a | grep -v $HOST | awk 'NR>1 {print $1}')
  docker system prune -af
  docker volume prune -f
}

# --------------- LDAP ---------------
# get my ad auth groups
myldaps() {
  curl -s -k --ntlm -u cable\\${NTID} "ldaps://adapps.cable.comcast.com:3269/dc=comcast,dc=com?memberOf?sub?(sAMAccountName=$NTID)"
}

# --------------- GITHUB ---------------
# git remote add origin from ghe
# connect [repo] [user - optional]
connect () {
  local user="${2:-$NTID}"
  local url='https://'$GITHUB_TOKEN'@github.comcast.com/'$user'/'$1'.git'
  git remote add origin $url
}

# git remote add origin of orginization from ghe
# connect [repo] [org - optional]
connect-org () {
  local org="${2:-$GITHUB_ORG}"
  local url='https://'$GITHUB_TOKEN'@github.comcast.com/'$org'/'$1'.git'
  git remote add origin $url
}

# clone repo from ghe
# clone [repo] [optional - user]
clone () {
  local user="${2:-$NTID}"
  local url='https://'$GITHUB_TOKEN'@github.comcast.com/'$user'/'$1'.git'
  git clone $url
}

# clone org repo
# clone [repo] [optional - organiztion name]
clone-org () {
  local org="${2:-$GITHUB_ORG}"
  local url='https://'$GITHUB_TOKEN'@github.comcast.com/'$org'/'$1'.git'
  git clone $url
}

# creates a repo on github
# create-repo [repo] ... this will only create repo in user space
create-repo() {
  curl -ss -H "Authorization: token $GITHUB_TOKEN" --data '{"name":"'$1'"}' https://github.comcast.com/api/v3/user/repos >> /dev/null
}

# deletes a repo on github
# be careful  ... only deletes in user space
delete-repo() {
  curl -ss -X DELETE -u $NTID:$GITHUB_TOKEN https://github.comcast.com/api/v3/repos/$NTID/$1 
}

# clones all the repositories ha ...
clone-all() {
  curl -ss -H "Authorization: token $GITHUB_TOKEN" https://github.comcast.com/api/v3/users/$NTID/repos | \
  grep -w '"name":' | sed 's/.*://' | rev | cut -c 2- | rev | \
  xargs -L1 -I '$' git clone https://$GITHUB_TOKEN@github.comcast.com/$NTID/$.git
}

# git push
gpo() {
  git push origin $1
}

# git add, commit, push
# gcgp "my commit message" develop
gcgp() {
  git add . && git commit -m "$1" && git push origin "$2"
}
