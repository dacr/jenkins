FROM dacr/jenkins-common
MAINTAINER David Crosson <crosson.david@gmail.com>


ENV JENKINS_URL      http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war
ENV JENKINS_WAR      $JENKINS_HOME/jenkins.war
ENV JENKINS_CLI      $JENKINS_HOME/cli.jar

RUN curl -SL $JENKINS_URL -o $JENKINS_WAR
RUN unzip -p $JENKINS_WAR WEB-INF/jenkins-cli.jar > $JENKINS_CLI

COPY init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy
RUN cd /tmp &&  \
    zip -g $JENKINS_WAR WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy && \
    rm -rf /tmp/WEB-INF

ADD jenkins.sh $JENKINS_HOME/
ADD jenkins-bootssh.sh $JENKINS_HOME/

ADD installplugins.sh $JENKINS_HOME/
RUN $JENKINS_HOME/installplugins.sh

RUN chown -R jenkins:jenkins "$JENKINS_HOME"
USER jenkins

EXPOSE 9999
EXPOSE 50000

CMD $JENKINS_HOME/jenkins-bootssh.sh

