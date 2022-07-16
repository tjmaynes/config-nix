#!/bin/bash

function pclone()
{
  REPO_NAME=$1
  GIT_REPO=$GIT_USERNAME/$REPO_NAME

  if [[ ! -d "$WORKSPACE_DIR" ]]; then
    mkdir -p "$WORKSPACE_DIR"
  fi

  if [[ -z "$REPO_NAME" ]]; then
    echo "Missing arg 1 'git repo name'"
  elif [[ ! -d "$WORKSPACE_DIR/$REPO_NAME" ]]; then
    git clone git@github.com:$GIT_REPO.git $WORKSPACE_DIR/$REPO_NAME

    [[ -d "$WORKSPACE_DIR/$REPO_NAME" ]] && cd $WORKSPACE_DIR/$REPO_NAME
  fi
}

# Originally found here: https://stackoverflow.com/a/32592965
function kill-process-on-port()
{
  PORT=$1

  if [[ -z $PORT ]]; then
    echo "Please provide a PORT to kill process from"
  else
    kill -9 $(lsof -t -i:$PORT)
  fi
}

function backup-github-repos()
{
  REPOS=$(curl -s "https://api.github.com/users/$GIT_USERNAME/repos" | python -c "import json, sys; obj=json.load(sys.stdin); lst=[str(obj[i]['name']) for i in range(len(obj))]; print ', '.join(str(p) for p in lst)")
  REPOS=($(echo $REPOS | tr "," "\n"))

  if [[ ! -d "$WORKSPACE_BACKUP_DIR" ]]; then
    mkdir -p "$WORKSPACE_BACKUP_DIR"
  fi

  for repo in "${REPOS[@]}"; do
    echo "Backing up $repo repo to $WORKSPACE_BACKUP_DIR"
    git clone https://github.com/$GIT_USERNAME/$repo.git $WORKSPACE_BACKUP_DIR/$repo
    tar -czf $repo.tar.gz $WORKSPACE_BACKUP_DIR/$repo
    rm -rf $WORKSPACE_BACKUP_DIR/$repo
  done
}

function get-ip-address()
{
  if [[ -z "$(command -v hostname)" ]]; then
    echo "Hostname is not installed on machine"
  else
    hostname -I | awk '{print $1}'
  fi
}

function start-ssh-agent()
{
  eval $(ssh-agent -s) && ssh-add $HOME/.ssh/id_rsa
}

function docker-clean-all()
{
  if [[ -n "$(command -v docker)" ]]; then
    docker stop $(docker container ls -a -q)
    docker system prune -a -f --all
    docker rm $(docker container ls -a -q)
  else
    echo "Please install 'docker' before running this command!"
  fi
}

function docker-stop-and-remove-image()
{
  if [[ -n "$(command -v docker)" ]]; then
    docker stop "$(docker ps | grep $1 | awk '{print $1}')"
    docker rm   "$(docker ps | grep $1 | awk '{print $1}')"
    docker rmi  "$(docker images | grep $1 | awk '{print $3}')" --force
  else
    echo "Please install 'docker' before running this command!"
  fi
}
