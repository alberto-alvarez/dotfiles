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

function cdcpub () {
   cd $MYSITES/cpub/public/$1
   guake -r cpub
}

function cdwebdev () {
   cd $MYSITES/webdev/public/$1
   guake -r webdev
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

function lmount () {
   grep $1 /etc/fstab | awk '{print $2}' | xargs sudo mount
}

function lumount () {
   grep $1 /etc/fstab | awk '{print $2}' | xargs sudo umount
}

function webdev () {
   declare -a services=("mysql" "apache2" "mongodb")

   for service in ${services[@]}
   do
      serviceStatus=`sudo service $service status | grep process | wc -l`
      if [ "$serviceStatus" == "1" ]
         then
         running $service
      else
         stopped $service
      fi
   done
}

function webdevoff () {
   declare -a services=("mysql" "apache2" "mongodb")

   for service in ${services[@]}
   do
      serviceStatus=`sudo service $service stop`
   done

   webdev
}

function webdevon () {
   declare -a services=("mysql" "apache2" "mongodb")

   for service in ${services[@]}
   do
      serviceStatus=`sudo service $service start`
   done

   webdev
}
