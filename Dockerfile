# Stage 1: build the app
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /app
# Copy sources and build
COPY pom.xml .
COPY src ./src
# Skip tests to speed up build (optionnel)
RUN mvn -B clean package -DskipTests

# Stage 2: runtime image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# Copy jar from build stage (assumes final artifact is target/*.jar)
COPY --from=build /app/target/*.jar app.jar

# Expose port (change si nécessaire)
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java","-jar","/app/app.jar"]