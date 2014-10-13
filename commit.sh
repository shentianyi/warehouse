#!/bin/bash
#$1=commit message,$2=additional branch you wanto merge
CURRENT="$(git symbolic-ref --short -q HEAD)"
echo "now you are on "$CURRENT

FULLBRANCH=('master' 'develop')
ELEMENTS=${#FULLBRANCH[@]}

if [ -n "$1" ]; then
	echo "commit message "$1
else
	echo "Please leave you commit message!!"
	exit
fi

#
git add .
git commit -m $1
git pull
git push origin $CURRENT