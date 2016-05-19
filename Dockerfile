FROM robeferre/tomcat:v7

# ----------------------------------------------------------
# App build using Dockerfile 
# ----------------------------------------------------------

MAINTAINER ROBERTO FERREIRA JUNIOR

RUN mkdir -p /devops/common/chef 

ADD node.json /devops/common/chef/

#chef_stuff
ADD chef_exec_22485.sh /chef_exec_22485.sh
RUN chmod 755 /*.sh && /chef_exec_22485.sh

#deploy_artifact
ADD avisoweb.war /usr/local/tomcat/webapps/avisoweb.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
