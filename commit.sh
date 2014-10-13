#!/bin/bash
BRANCH="$(git symbolic-ref --short -q HEAD)"
echo "now you are on "$BRANCH
if [ -n "$1" ]; then
	echo $1
else
	echo "Nothing passed!"
fi