FROM openjdk:11
ADD target/my-app-0.0.1-SNAPSHOT.jar sample-maven-project.jar
EXPOSE 3000
