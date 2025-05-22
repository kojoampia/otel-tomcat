FROM tomcat:10.1.25-jre21-temurin-jammy
LABEL maintainer="kojo.ampia@jojoaddison.net"

ADD otel-javaagent.jar /usr/local/tomcat/
ADD setenv.sh /usr/local/tomcat/bin/
ADD demo.war /usr/local/tomcat/webapps/

RUN ["chmod", "+x", "/usr/local/tomcat/bin/setenv.sh"]

EXPOSE 8080
CMD ["catalina.sh", "run"]