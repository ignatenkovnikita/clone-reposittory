#!/bin/bash

echo "Enter token"
read -r TOKEN

echo "Enter organization name"
read -r ORGNAME

echo "Enter repo dir for cloning"
read -r REPODIR

echo "Enter start page repositories"
read -r STARTPAGE

echo "Enter end page repositories"
read -r ENDPAGE

echo "Start Cloning"

function getRepoName() {
  local token=$1
  local orgName=$2
  local page=$3
  local response=$(curl --location --request GET 'https://api.github.com/orgs/'$orgName'/repos?per_page=1&page='$page'' --header 'Authorization: Bearer '$token'' 2>/dev/null)
  echo $response | jq -r '.[0].name // empty'
}

function cloneRepo() {
  local token=$1
  local name=$2
  local orgName=$3
  git clone https://$token@github.com/$orgName/$name.git $REPODIR/$orgName-$name 2>/dev/null

}

for (($STARTPAGE; $STARTPAGE <= $ENDPAGE; STARTPAGE++)); do

  repo_name=$(getRepoName $TOKEN $ORGNAME $STARTPAGE)

  if [ -z "$repo_name" ]; then
    break
  else
    echo "Cloning $repo_name"
  fi

  cloneRepo $TOKEN $repo_name $ORGNAME

done

echo "End Cloning"
