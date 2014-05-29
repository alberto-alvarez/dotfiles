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
   grep $1 /etc/fstab | awk '{print $2}' | xargs /usr/bin/sudo /bin/mount
}

function lumount () {
   grep $1 /etc/fstab | awk '{print $2}' | xargs /usr/bin/sudo /bin/umount
}

function webdev () {
   declare -a services=("mysql" "apache2" "mongodb")

   for service in ${services[@]}
   do
      serviceStatus=`sudo service $service status | grep '.*[0-9]\{3,\}.*' | wc -l`
      if [ "$serviceStatus" == "1" ]
         then
         running 'RUNNING' $service
      else
         stopped 'STOPPED' $service
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

function checkmounts() {
    mounts=(`cat /etc/fstab | grep '192.168' | awk '{print $2}'`)
    mountLabels=(`cat /etc/fstab | grep '192.168' | awk '{print $2}' | awk -F  "/" '{print($(NF))}'`)
    COUNTER=0
    for mount in ${mounts[@]}; do
       mountStatus=(`cat /proc/mounts | grep $mount | wc -l`)
       mountLabel=${mountLabels[$COUNTER]}
      if [ "$mountStatus" == "1" ]
         then
         running $COUNTER "$mountLabel: $mount"
      else
         stopped $COUNTER "$mountLabel: $mount"
      fi
      COUNTER=$[$COUNTER +1]
    done
     user "Toggle by [#] number, [G]o to, [M]ount all, [U]nmount all or [C]ancel (default): "
     read -n 2 action
   echo ""
   if [[ $action != *[!0-9]* ]]
   then
       toggleMount "${mounts[$action]}"
   else
     case "$action" in
       [cC] )
         return;;
       [mM] )
         for mount in ${mounts[@]}; do
            sudo mount $mount
         done;;
       [uU] )
         for mount in ${mounts[@]}; do
            sudo umount $mount
         done;;
       [gG] )
         user "Where to go? Type the [#] number: "
         read -n 2 goTo
         cd "${mounts[$goTo]}"
         echo ""
         return;;
       * )
         return;;
      esac
   fi
   checkmounts

}

function toggleMount() {
    isMounted=(`cat /proc/mounts | grep $1 | wc -l`)
      if [ "$isMounted" == "1" ]
      then
         sudo umount "$1"
      else
         sudo mount "$1"
      fi
}
