# jenkins master docker image
jenkins master image with enabled jnlp agent port (50000) for slaves

usage :

 * quick :
   - `docker run -d -p 9999:9999 -p 50000:50000 --name myjenkins dacr/jenkins`
 * with volume storage :
   - `docker create -v /var/jenkins_home --name jenkins-data dacr/jenkins /bin/true`
   - `docker run -d -p 9999:9999 -p 50000:50000 --volumes-from jenkins-data --name myjenkins dacr/jenkins`


Adding a slave :

 * `docker run -d -e SLAVE_NAME=slave1 -e MASTER_URL=http://master_ip:9999/ --name myslave-1 dacr/jenkins-slave`

