#!/bin/bash 

echo GitHib 
echo git clone git@github.com:username/repository.git
echo git add .
echo git commit -m "message"
echo git push origin master
echo git remote add upstream git://github.com/username/repository.git 
echo -- Assign the original repo to a remote called "upstream"
echo git fetch upstream
echo -- Fetches any new changes from the original repo
echo git merge upstream/master
echo -- Merges any changes fetched into your working files

