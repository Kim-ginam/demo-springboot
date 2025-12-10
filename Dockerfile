# 1. Build Stage
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src

# mvnw가 없어도 mvn으로 대체 빌드 가능하도록 처리
RUN ./mvnw -q -e -DskipTests package || mvn -q -e -DskipTests package

# 2. Run Stage
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
