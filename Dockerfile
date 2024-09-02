FROM maven:3.8.4-openjdk-17-slim AS build

# Copy the project files into the image.
COPY src /home/app/src
COPY pom.xml /home/app

# Build the application.
RUN mvn -f /home/app/pom.xml clean package -DskipTests

# Use OpenJDK for running the application.
FROM openjdk:17-alpine

# Copy the built artifact from the 'build' stage.
COPY --from=build /home/app/target/config-server-*.jar /usr/local/lib/config-server.jar

# Expose the port the app runs on.
EXPOSE 8888

# Run the application.
CMD ["java", "-jar", "/usr/local/lib/config-server.jar"]