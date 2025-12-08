# ----- Build Stage -----
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the project
COPY src ./src

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# ----- Run Stage -----
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose Spring Boot port
EXPOSE 8087

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]