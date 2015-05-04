#!/bin/bash

SRC="http://127.0.0.1:9999"
CLI="java -jar $JENKINS_CLI -s $SRC"

waitON() {
  while [ "`$CLI wait-node-online '' >/dev/null 2>&1 ; echo $? `" != 0 ]; do sleep 2 ; done
}
waitOFF() {
  while [ "`$CLI wait-node-online '' >/dev/null 2>&1 ; echo $? `" == 0 ]; do sleep 2 ; done
}

start() {
  $JENKINS_HOME/jenkins.sh --daemon --logfile /tmp/jenkins-init.log
  waitON
}
shutdown() {
  $CLI shutdown
  waitOFF
}

start
$CLI install-plugin swarm
$CLI install-plugin sbt
$CLI install-plugin github
$CLI install-plugin deploy
shutdown
start
$CLI list-plugins
shutdown

