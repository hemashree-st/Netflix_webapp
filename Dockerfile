FROM tomcat:9.0
COPY ./target/ajio.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8084
CMD ["catalina.sh","run"]