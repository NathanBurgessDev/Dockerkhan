FROM gradle:7-jdk17-jammy
#FROM eclipse-temurin:17-jdk-jammy

RUN mkdir -p /home/gradle/project
WORKDIR /home/gradle/project

EXPOSE 8000

# App...
#RUN gradle build
#COPY ...
#CMD ["gradle","run"]

# Dev...
VOLUME ["/home/gradle/project"]
CMD ["bash"]
