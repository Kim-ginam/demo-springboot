# 1. Build Stage: Maven 공식 이미지를 사용하여 Maven 설치 없이 'mvn' 명령어 사용
# 이 이미지는 JDK와 Maven이 모두 설치되어 있어 가장 안정적입니다.
FROM maven:3.9-eclipse-temurin-17 AS build

# 작업 디렉토리 설정
WORKDIR /app

# 프로젝트 루트의 모든 파일 (pom.xml, src, .mvn, mvnw 포함)을 복사합니다.
# .gitignore에 의해 무시되지 않는 모든 파일이 복사됩니다.
COPY . .

# JAR 파일 빌드 실행 (테스트 스킵)
# 이미지가 mvn 명령어를 포함하고 있으므로, mvnw 없이 바로 mvn을 사용합니다.
RUN mvn package -DskipTests

# -----------------------------------------------------------------------

# 2. Run Stage: 최종 실행 환경
# 실행에 필요한 경량화된 JRE 환경을 사용합니다.
FROM eclipse-temurin:17-jre

# 작업 디렉토리 설정
WORKDIR /app

# 빌드 스테이지에서 생성된 JAR 파일만 복사
COPY --from=build /app/target/*.jar app.jar

# Cloud Run에서 사용할 포트 노출 (Cloud Run은 PORT 환경변수를 사용하지만, 명시적으로 EXPOSE 하는 것이 좋습니다.)
EXPOSE 8080

# 애플리케이션 실행 명령어 정의
ENTRYPOINT ["java", "-jar", "app.jar"]
