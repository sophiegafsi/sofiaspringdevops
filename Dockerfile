# Use Maven to build the project
FROM maven:3.9.3-eclipse-temurin-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
#RUN mvn dependency:go-offline
RUN mvn dependency:go-offline -Dmaven.wagon.http.retryHandler.count=5

# Copy the source code
COPY src ./src

# Build the jar (skip tests if you want faster build)
RUN mvn clean package -DskipTests

# Use a lightweight Java runtime image
FROM eclipse-temurin:17-jdk-alpine

COPY settings.xml /root/.m2/settings.xml


# Set working directory
WORKDIR /app

# Copy the jar from the build stage
COPY --from=build /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8089

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
