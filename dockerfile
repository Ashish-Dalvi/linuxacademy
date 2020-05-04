# Pull tomcat latest image from dockerhub
FROM tomcat:8.0.51-jre8-alpine
MAINTAINER email2satyam88@gmail.com
# copy war file on to container
COPY ./target/linuxacademy.war /usr/local/tomcat/webapps
EXPOSE  8080
USER linuxacademy
WORKDIR /usr/local/tomcat/webapps
CMD ["catalina.sh","run"]