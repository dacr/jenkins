#!/bin/bash

SSHKEY=$HOME/.ssh/id_rsa

if [ ! -f $SSHKEY ] ; then
  echo "generating ssh key"
  ssh-keygen -q -t rsa -f $SSHKEY -N ''
fi
$JENKINS_HOME/jenkins.sh "$@"

