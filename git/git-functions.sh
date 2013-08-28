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
