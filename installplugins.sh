#!/bin/bash

SRC="http://127.0.0.1:9999"
CLI="java -jar $JENKINS_CLI -s $SRC"

waitON() {
  while [ "`$CLI wait-node-online '' >/dev/null 2>&1 ; echo $? `" != 0 ]; do sleep 1 ; done
}
waitOFF() {
  while [ "`$CLI wait-node-online '' >/dev/null 2>&1 ; echo $? `" == 0 ]; do sleep 1 ; done
}

start() {
  $JENKINS_HOME/jenkins.sh --daemon --logfile /tmp/jenkins-init.log
  waitON
  echo "WE have to wait for jenkins to be really ready... TO BE ENHANCED (wait-node-online is not enough :( )"
  sleep 15
}
shutdown() {
  $CLI safe-shutdown
  waitOFF
}

start
curl -sL $SRC/pluginManager/checkUpdates -o /dev/null
echo "WE have to wait for jenkins to have finished the check for updates operation... TO BE ENHANCED"
sleep 10
UPDATE_LIST=$( $CLI list-plugins | grep -e ')$' | awk '{ print $1 }' );
if [ -n "$UPDATE_LIST" ] ; then 
  $CLI install-plugin $UPDATE_LIST
fi
$CLI install-plugin swarm sbt github deploy gatling -restart
waitOFF
waitON
$CLI list-plugins
shutdown

