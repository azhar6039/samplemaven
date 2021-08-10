FROM java:8
ADD target/my-app-0.0.1-SNAPSHOT.jar sample-maven-project.jar
EXPOSE 8080
CMD java - jar sample-maven-project.jar
