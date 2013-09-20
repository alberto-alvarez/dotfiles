#!/bin/bash

# my git related functions

function gitst () {
   git status -sb $@
}

function gitlog () {
   git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $@
}

function gitclog () {
   git log --pretty=format:'%s' --abbrev-commit --date=relative $@
}

function gitdiff () {
   git diff --minimal --patience --word-diff $@
}

function gitrm () {
   git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm
}

function gitlogfind () {
   git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --all -i --grep=$@
}

function gitbranchStart () {
   branch=`git branch | grep \* | awk '{print $2}'`
   git checkout -b $branch-$1
}

function gitbranchClose () {
   set -e
   currentBranch=`git branch | grep \* | awk '{print $2}'`
   parentBranch=`git branch | grep \* | awk '{print $2}' | awk -F- '{print $1}'`
   git checkout $parentBranch
   git merge --no-ff $currentBranch
   git branch -D $currentBranch
}

function gitpush () {
   branch=`git branch | grep \* | awk '{print $2}'`
   git push $1 $branch
}

function gitcommit () {
   branch=`git branch | grep \* | awk '{print $2}'`
   git add .
   git commit -m "$branch: $@"
}

