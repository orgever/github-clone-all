#!/bin/bash

PER_PAGE=100
PAGE=1
URL="https://api.github.com/$GITHUB_TYPE/$GITHUB_ORG/repos?per_page=$PER_PAGE&page=$PAGE"

ssh-keyscan github.com >> ~/.ssh/known_hosts

JSON=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  $URL)

CNT=$(echo $JSON | jq '. | length')

while [[ $CNT -gt 0 ]]
do
    echo $JSON | jq ".[].name" |
	while read NAME
	do
	    cd $DATA_DIR
	    NAME=`echo $NAME | tr -d '"'`
	    echo "Clone repo: $NAME"
	    URL="git@github.com:$GITHUB_ORG/$NAME.git"
	    git clone $URL $DATA_DIR/$NAME
	    cd $DATA_DIR/$NAME
	    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
	    git fetch --all
	    git pull --all
	done
    
    PAGE=$(echo "$PAGE + 1" | bc)
    URL="https://api.github.com/$GITHUB_TYPE/$GITHUB_ORG/repos?per_page=$PER_PAGE&page=$PAGE"
    JSON=$(curl \
	       -H "Accept: application/vnd.github+json" \
	       -H "Authorization: Bearer $GITHUB_TOKEN" \
	       $URL)

    CNT=$(echo $JSON | jq '. | length')
done
