#!/bin/bash

if [ -z "$JENKINS_HOME" ] ; then
  JENKINS_HOME=/home/jenkins
fi
if [ -z "$JENKINS_WAR" ] ; then
  JENKINS_WAR=$JENKINS_HOME/jenkins.war
fi
JENKINS_LOGS=$JENKINS_HOME/logs
JENKINS_HTTP_PORT=9999
JENKINS_HTTPS_PORT=9997
JENKINS_AJP_PORT=9998
JENKINS_JMX_PORT=9996

if [ ! -d $JENKINS_LOGS ] ; then
  mkdir -p $JENKINS_LOGS
fi

if [ ! -f $JENKINS_WAR ] ; then
  curl -L http://mirrors.jenkins-ci.org/war/latest/jenkins.war -o $JENKINS_WAR
fi

JAVA_OPTS="-server -Xmx2g -Xms512m"

JAVA_OPTS=$JAVA_OPTS" -XX:NewRatio=8 -XX:SurvivorRatio=8"
JAVA_OPTS=$JAVA_OPTS" -XX:MaxPermSize=256M -XX:PermSize=256M"

JAVA_OPTS=$JAVA_OPTS" -XX:+UseConcMarkSweepGC -XX:+UseParNewGC"
JAVA_OPTS=$JAVA_OPTS" -XX:+CMSParallelRemarkEnabled"
JAVA_OPTS=$JAVA_OPTS" -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark"
JAVA_OPTS=$JAVA_OPTS" -XX:+ExplicitGCInvokesConcurrent"
JAVA_OPTS=$JAVA_OPTS" -XX:+CMSClassUnloadingEnabled"
JAVA_OPTS=$JAVA_OPTS" -XX:+UseCMSInitiatingOccupancyOnly"
JAVA_OPTS=$JAVA_OPTS" -XX:CMSInitiatingOccupancyFraction=80"

JAVA_OPTS=$JAVA_OPTS" -Djava.net.preferIPv4Stack=true"
JAVA_OPTS=$JAVA_OPTS" -Dsun.net.inetaddr.ttl=60"
JAVA_OPTS=$JAVA_OPTS" -Dnetworkaddress.cache.negative.ttl=10"

JAVA_OPTS=$JAVA_OPTS" -Dcom.sun.management.jmxremote.port=$JENKINS_JMX_PORT"
JAVA_OPTS=$JAVA_OPTS" -Dcom.sun.management.jmxremote.ssl=false"
JAVA_OPTS=$JAVA_OPTS" -Dcom.sun.management.jmxremote.authenticate=false"
JAVA_OPTS=$JAVA_OPTS" -verbose:gc -XX:+PrintGC -XX:+PrintGCDetails"
JAVA_OPTS=$JAVA_OPTS" -XX:+PrintGCTimeStamps"
JAVA_OPTS=$JAVA_OPTS" -Xloggc:$JENKINS_LOGS/GC_`date '+%y%m%d_%H%M%S'`.log"

JENKINS_OPTS=" --httpPort=$JENKINS_HTTP_PORT"
JENKINS_OPTS=$JENKINS_OPTS" --ajp13Port=$JENKINS_AJP_PORT"
JENKINS_OPTS=$JENKINS_OPTS" --httpsPort=$JENKINS_HTTPS_PORT"

java $JAVA_OPTS -jar $JENKINS_WAR $JENKINS_OPTS "$@"

