# ---------- Fase de build ----------
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY api/pom.xml .
RUN mvn dependency:go-offline

COPY api/src ./src
RUN mvn package -DskipTests

# ---------- Fase de runtime ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]