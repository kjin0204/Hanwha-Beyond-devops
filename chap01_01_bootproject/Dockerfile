# FROM 사용할 플랫폼을(이미지) 받아옴
FROM eclipse-temurin:17-jre-alpine
#받아온 이미지의 시작 위치를 지정(플랫폼 마다 시작위치는 다를 수있음) /app 이다른 이름이 될 수있음
WORKDIR /app 
#내 빌드 파일을 .app 폴더에 복사
COPY build/libs/*.jar ./ 
# plain이 붙은 파일을 제외하고 app.jar로 만들어 달라는 명령어 -v 가 해당하는 파일을 뺴고
RUN mv $(ls *.jar | grep -v plain) app.jar 

# 파일을 아래와 같이 샐행해라 
ENTRYPOINT ["java", "-jar", "app.jar"]

