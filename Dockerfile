FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

COPY . .
RUN mvn clean package -pl service -am -Pexclude-spam-filter -DskipTests
RUN ls -al /app/service/target/

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/service/target/TextSecureServer-20250131.1.1-dirty-SNAPSHOT.jar /app/signal-server.jar
RUN mkdir /app/config
RUN ls -al /app
EXPOSE 50051
# Run the Java application
CMD ["java", "-jar", "-Dsecrets.bundle.filename=/app/config/secrets-bundle.yml", "signal-server.jar", "server", "/app/config/signal.yml"]

