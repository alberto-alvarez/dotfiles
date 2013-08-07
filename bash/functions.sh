#!/bin/bash

# my bash functions

function music () {
   guake -r cmus
   cmus
}

function cdsubmit () {
   cd $MYSITES/submit/public/$1
   guake -r "Submit $1"
}

function cdhost () {
   cd $MYSITES/host/public/$1
   guake -r "Host $1"
}

function cdportais () {
   cd $MYSITES/portais/public/$1
   guake -r "Portais $1"
}

function cddotfiles () {
   cd /home/$USER/.dotfiles
   guake -r dotfiles
}

function goturing () {
   guake -r turing
   ssh lpanebr@192.168.1.10
}

function gogutenberg () {
   guake -r gutenberg
   ssh lpanebr@192.168.1.8
}

function findhere () {
   grep -irn "$@" --exclude-dir='.git' .
}