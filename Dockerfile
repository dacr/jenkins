FROM dacr/jenkins-common
MAINTAINER David Crosson <crosson.david@gmail.com>


ENV JENKINS_URL      http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war
ENV JENKINS_WAR      /jenkins/jenkins.war
ENV JENKINS_CLI      /jenkins/cli.jar

RUN mkdir /jenkins/

RUN curl -SL $JENKINS_URL -o $JENKINS_WAR
RUN unzip -p $JENKINS_WAR WEB-INF/jenkins-cli.jar > $JENKINS_CLI

COPY init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy
RUN cd /tmp &&  \
    zip -g $JENKINS_WAR WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy && \
    rm -rf /tmp/WEB-INF

ADD jenkins.sh /jenkins/

#ADD installplugins.sh /jenkins/
#RUN /jenkins/installplugins.sh

RUN chown -R jenkins:jenkins "$JENKINS_HOME"
RUN chown -R jenkins:jenkins /jenkins

ADD start.sh /jenkins/start.sh
RUN chmod a+rx /jenkins/start.sh

USER jenkins

EXPOSE 9999
EXPOSE 50000

ENTRYPOINT ["/jenkins/start.sh"]

