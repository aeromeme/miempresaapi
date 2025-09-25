FROM eclipse-temurin:21-jdk-jammy as build

WORKDIR /workspace/app

COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY gradlew .
COPY src src

RUN chmod +x gradlew
RUN ./gradlew build -x test

FROM eclipse-temurin:21-jre-jammy

RUN apt-get update && apt-get install -y postgresql-client

VOLUME /tmp
COPY --from=build /workspace/app/build/libs/*.jar app.jar
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENV SPRING_PROFILES_ACTIVE=docker
ENV SPRING_DATASOURCE_USERNAME=postgres
ENV SPRING_DATASOURCE_PASSWORD=postgres123

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]