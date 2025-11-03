FROM node:lts-alpine
## cul(client-url) 설치 , 포스트맨과 같이 http 요청을 보내는 용도
RUN apk add --no-cache curl

WORKDIR /app

COPY . .

RUN npm install

## npm run dev --host 0.0.0.0
## --host 0.0.0.0 네트워크 인터페이스에서 접속을 허용(Docker 컨테이너 외부의 아무 IP에서나 접속 가능)
## 중간에 이중 대쉬(--)는 npm 명령어와 구분하기 위한 구분자
CMD ["npm","run","dev","--","--host","0.0.0.0"]