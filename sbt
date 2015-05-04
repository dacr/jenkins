#!/bin/bash

JAVA_OPTS=""
JAVA_OPTS=$JAVA_OPTS" -XX:PermSize=128M -XX:MaxPermSize=256m"
JAVA_OPTS=$JAVA_OPTS" -XX:ReservedCodeCacheSize=128M"
JAVA_OPTS=$JAVA_OPTS" -Dscala.color"

JAVA_OPTS=$JAVA_OPTS" -Xms64M -Xmx1500m"

java $JAVA_OPTS $SBT_OPTS -jar `dirname $0`/sbt-launch.jar "$@"

