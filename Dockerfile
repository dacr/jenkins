FROM centos:centos7
MAINTAINER David Crosson <crosson.david@gmail.com>

ENV SBT_LAUNCHER_URL http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.8/sbt-launch.jar
ENV JENKINS_URL      http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war
ENV JENKINS_HOME     /var/jenkins_home
ENV JENKINS_WAR      $JENKINS_HOME/jenkins.war
ENV JENKINS_CLI      $JENKINS_HOME/cli.jar

RUN mv /etc/localtime /etc/localtime.bak && \
    ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

RUN   rpm -i http://pkgs.repoforge.org/proxytunnel/proxytunnel-1.9.0-1.el7.rf.x86_64.rpm
RUN   yum -y install git
RUN   yum -y install zip
RUN   yum -y install unzip
RUN   yum -y install java
RUN   yum -y install maven

RUN mkdir -p /opt/sbt/
RUN curl -SL $SBT_LAUNCHER_URL -o /opt/sbt/sbt-launch.jar
ADD sbt /opt/sbt/
RUN echo 'PATH=$PATH:/opt/sbt/' > /etc/profile.d/sbt.sh

RUN useradd -d $JENKINS_HOME -m -s /bin/bash jenkins
RUN mkdir $JENKINS_HOME/logs
RUN usermod -m -d "$JENKINS_HOME" jenkins && chown -R jenkins "$JENKINS_HOME"

COPY init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy
RUN curl -SL $JENKINS_URL -o $JENKINS_WAR
RUN unzip -p $JENKINS_WAR WEB-INF/jenkins-cli.jar > $JENKINS_CLI
RUN cd /tmp &&  \
    zip -g $JENKINS_WAR WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy && \
    rm -rf /tmp/WEB-INF
ADD jenkins.sh $JENKINS_HOME/

VOLUME $JENKINS_HOME
USER jenkins

ADD installplugins.sh $JENKINS_HOME/
RUN $JENKINS_HOME/installplugins.sh

EXPOSE 9999
EXPOSE 50000

CMD $JENKINS_HOME/jenkins.sh

