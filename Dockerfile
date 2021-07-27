FROM acrameastusprodsre.azurecr.io/elc/sre/baseimage/release/java/openjdk/alpine/java8-alpine:release-20200430
ADD target/my-app-0.0.1-SNAPSHOT.jar sample-maven-project.jar
