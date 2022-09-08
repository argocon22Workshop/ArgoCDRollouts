#!/bin/bash

ColorOff='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'

checkCmd () {
  if ! command -v "$1" &> /dev/null
  then
    echo -e "$Red $1 could not be found! $ColorOff"
    exit
  else
    echo -e "$Green $1 command found! $ColorOff"
  fi
}

checkK8sRunning() {
  if docker ps > /dev/null 2>&1; then
    echo -e "$Green Docker is running! $ColorOff"
  else
    echo -e "$Red Docker is not running, please start Docker Desktop! $ColorOff"
  fi

  if kubectl get pods > /dev/null 2>&1; then
    echo -e "$Green Kubernetes is running and we are able to connect! $ColorOff"
  else
    echo -e "$Red Could not connect to kubernetes, please check Docker Desktop settings https://docs.docker.com/desktop/kubernetes/#enable-kubernetes $ColorOff"
  fi
}

checkContextDD() {
  if kubectl config current-context | grep -qw 'docker-desktop'; then
    echo -e "$Green Current Kubernetes context is set to docker-desktop! $ColorOff"
  else
    CURRENT_CONTEXT=$(kubectl config current-context)
    echo -e "$Yellow Current Kuberentes context is $CURRENT_CONTEXT, please make sure this is correct! $ColorOff"
  fi
}

checkCmd "kubectl"
checkCmd "docker"
checkCmd "brew"
checkCmd "argocd"

checkK8sRunning
checkContextDD
