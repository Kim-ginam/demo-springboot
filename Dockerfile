# 1. Run Stage: 최종 실행 환경 (가장 가벼운 JRE 환경 사용)
FROM eclipse-temurin:17-jre

# 작업 디렉토리 설정
WORKDIR /app

# Cloud Build 환경에서 이미 빌드된 JAR 파일을 바로 복사합니다.
# 'target' 디렉토리는 Cloud Build Step 1 이후에도 존재합니다.
COPY target/*.jar app.jar

# Cloud Run에서 사용할 포트 노출
EXPOSE 8080

# 애플리케이션 실행 명령어 정의
ENTRYPOINT ["java", "-jar", "app.jar"]
