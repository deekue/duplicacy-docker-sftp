#!/bin/bash
#
# create SSH host keys

if [ -n "$1" -a -d "$1" ] ; then
  # create SSHD host keys
  for cipher in ecdsa rsa dsa ; do 
    keyfile="$1/ssh_host_${cipher}_key"
    [ ! -r "$keyfile" ] && ssh-keygen -f "$keyfile" -N '' -t ${cipher}
  done

  # create dir for duplicacy user's authorized_keys file
  mkdir "$1/duplicacy"
  touch "$1/duplicacy/authorized_keys"
else
  echo usage: $(basename -- "$0") '<key dir>' >&2
  exit 1
fi
