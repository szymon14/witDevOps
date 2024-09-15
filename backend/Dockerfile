# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-alpine

# Set environment variables for test
ENV SPRING_PROFILES_ACTIVE=test
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/postgres
ENV SPRING_DATASOURCE_USERNAME=postgres
ENV SPRING_DATASOURCE_PASSWORD=wit2024
ENV SPRING_PORT=32000

# Set the working directory to /app
WORKDIR /app

# Make port 32000 available to the world outside this container
EXPOSE 32000

# The application's jar file
ARG JAR_FILE=target/SzymonKucBackend-1.0-exec.jar

# Add the application's jar to the container
COPY ${JAR_FILE} app.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
