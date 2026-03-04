# ── Stage 1: Build ──
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Copy Maven wrapper & config first (better layer caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (cached unless pom.xml changes)
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Copy source code and build
COPY src src
COPY application.yml .
RUN ./mvnw package -DskipTests -B

# ── Stage 2: Runtime ──
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Create non-root user
RUN addgroup -S questify && adduser -S questify -G questify

# Copy the built JAR
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar

# Copy application config
COPY --from=build /app/application.yml .

# Switch to non-root user
USER questify

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar", "--spring.config.location=file:./application.yml"]
