# Stage 1: Build
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -q
COPY src/ src/
RUN ./mvnw package -DskipTests -q

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN addgroup -S petclinic && adduser -S petclinic -G petclinic
COPY --from=builder /app/target/*.jar app.jar
USER petclinic
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
