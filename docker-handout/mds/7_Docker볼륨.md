# 7. Docker 볼륨

## 7-1. Docker 볼륨 개요

### 7-1-1. Docker 볼륨이란?

- Docker 볼륨은 컨테이너가 생성한 데이터를 영구적으로 저장하기 위한 메커니즘이다.
- 컨테이너는 기본적으로 임시 저장소를 사용하므로, 컨테이너가 삭제되면 내부 데이터도 함께 사라진다.
- 볼륨을 사용하면 컨테이너의 생명주기와 독립적으로 데이터를 보존할 수 있다.

### 7-1-2. 볼륨이 필요한 이유

1. **데이터 영속성(Persistence)**: 컨테이너를 삭제하거나 재생성해도 데이터가 유지된다.
2. **데이터 공유**: 여러 컨테이너 간 데이터를 공유할 수 있다.
3. **백업 및 마이그레이션**: 볼륨 데이터를 쉽게 백업하고 다른 환경으로 이동할 수 있다.
4. **성능 향상**: Docker가 관리하는 볼륨은 바인드 마운트보다 성능이 우수하다.

### 7-1-3. 볼륨 vs 바인드 마운트

| 구분 | 볼륨(Volume) | 바인드 마운트(Bind Mount) |
| --- | --- | --- |
| 관리 주체 | Docker가 관리 | 사용자가 직접 호스트 경로 지정 |
| 저장 위치 | Docker 영역 (/var/lib/docker/volumes/) | 호스트의 임의 경로 |
| 이식성 | 높음 (Docker 명령어로 관리) | 낮음 (호스트 경로에 의존) |
| 성능 | 높음 | 상대적으로 낮음 |
| 사용 사례 | 프로덕션 환경, 데이터베이스 데이터 | 개발 환경, 소스코드 동기화 |

## 7-2. 볼륨 기본 명령어

### 7-2-1. 볼륨 생성하기

- 새로운 볼륨을 생성할 때 `docker volume create` 명령어를 사용한다.

  > $ docker volume create [볼륨이름]

  ```powershell
  $ docker volume create my-volume
  ```

### 7-2-2. 볼륨 목록 조회하기

- 현재 생성된 볼륨 목록을 확인할 때 `docker volume ls` 명령어를 사용한다.

  ```powershell
  $ docker volume ls
  ```

### 7-2-3. 볼륨 상세 정보 확인하기

- 특정 볼륨의 상세 정보를 확인할 때 `docker volume inspect` 명령어를 사용한다.

  ```powershell
  $ docker volume inspect my-volume
  ```

### 7-2-4. 볼륨 삭제하기

- 사용하지 않는 볼륨을 삭제할 때 `docker volume rm` 명령어를 사용한다.

  ```powershell
  $ docker volume rm my-volume
  ```

- 사용하지 않는 모든 볼륨을 일괄 삭제할 때 `docker volume prune` 명령어를 사용한다.

  ```powershell
  $ docker volume prune
  ```

### 7-2-5. 컨테이너에 볼륨 마운트하기

- 컨테이너 실행 시 `-v` 또는 `--volume` 옵션을 사용하여 볼륨을 마운트한다.

  > $ docker run -v [볼륨이름]:[컨테이너내부경로] [이미지명]

  ```powershell
  $ docker run -v my-volume:/app/data nginx
  ```

## 7-3. 실습: MariaDB 데이터 영속성과 Spring Boot 연동

### 7-3-1. MariaDB 컨테이너 실행 (볼륨 없이)

- 볼륨 없이 MariaDB 컨테이너를 실행하여 데이터 유실을 확인해 볼 것이다.

  ```powershell
  $ docker run --name mariadb-test -e MARIADB_ROOT_PASSWORD=root1234 -e MARIADB_DATABASE=testdb -p 3310:3306 -d mariadb:latest
  ```

- MariaDB 컨테이너에 접속하여 테이블을 생성하고 데이터를 입력한다.

  ```powershell
  $ docker exec -it mariadb-test mariadb -u root -p
  ```

- 비밀번호 입력 후 다음 SQL을 실행한다.

  ```sql
  USE testdb;
  
  CREATE TABLE calculation_history (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      num1 INT NOT NULL,
      num2 INT NOT NULL,
      result INT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
  
  INSERT INTO calculation_history (num1, num2, result) VALUES (10, 20, 30);
  INSERT INTO calculation_history (num1, num2, result) VALUES (5, 15, 20);
  
  SELECT * FROM calculation_history;
  
  exit;
  ```

- 컨테이너를 중지하고 삭제한다.

  ```powershell
  $ docker stop mariadb-test
  $ docker rm mariadb-test
  ```

- 동일한 명령어로 컨테이너를 다시 실행하고 데이터를 확인한다.

  ```powershell
  $ docker run --name mariadb-test -e MARIADB_ROOT_PASSWORD=root1234 -e MARIADB_DATABASE=testdb -p 3310:3306 -d mariadb:latest
  
  $ docker exec -it mariadb-test mariadb -u root -p
  ```

  ```sql
  USE testdb;
  SHOW TABLES;
  -- 테이블이 없음을 확인할 수 있다.
  exit;
  ```

> 컨테이너를 삭제했기 때문에 이전에 생성한 테이블과 데이터가 모두 사라졌음을 확인할 수 있다.

### 7-3-2. MariaDB + 볼륨 사용하기

- 이전 컨테이너를 정리한다.

  ```powershell
  $ docker stop mariadb-test
  $ docker rm mariadb-test
  ```

- 볼륨을 생성한다.

  ```powershell
  $ docker volume create mariadb-volume
  $ docker volume ls
  ```

- 볼륨을 마운트하여 MariaDB 컨테이너를 실행한다.

  ```powershell
  $ docker run --name mariadb-persist -e MARIADB_ROOT_PASSWORD=root1234 -e MARIADB_DATABASE=calcdb -p 3310:3306 -v mariadb-volume:/var/lib/mysql -d mariadb:latest
  ```

> MariaDB는 `/var/lib/mysql` 경로에 데이터를 저장하므로 이 경로에 볼륨을 마운트한다.

- 컨테이너에 접속하여 테이블을 생성하고 데이터를 입력한다.

  ```powershell
  $ docker exec -it mariadb-persist mariadb -u root -p
  ```

  ```sql
  USE calcdb;
  
  CREATE TABLE calculation_history (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      num1 INT NOT NULL,
      num2 INT NOT NULL,
      result INT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
  
  INSERT INTO calculation_history (num1, num2, result) VALUES (100, 200, 300);
  INSERT INTO calculation_history (num1, num2, result) VALUES (50, 50, 100);
  
  SELECT * FROM calculation_history;
  
  exit;
  ```

- 컨테이너를 중지하고 삭제한다.

  ```powershell
  $ docker stop mariadb-persist
  $ docker rm mariadb-persist
  ```

- 동일한 볼륨을 사용하여 컨테이너를 다시 실행한다.

  ```powershell
  $ docker run --name mariadb-persist -e MARIADB_ROOT_PASSWORD=root1234 -e MARIADB_DATABASE=calcdb -p 3310:3306 -v mariadb-volume:/var/lib/mysql -d mariadb:latest
  
  $ docker exec -it mariadb-persist mariadb -u root -p
  ```

  ```sql
  USE calcdb;
  SELECT * FROM calculation_history;
  -- 이전에 입력한 데이터가 그대로 유지되어 있음을 확인할 수 있다.
  exit;
  ```

> 볼륨을 사용했기 때문에 컨테이너를 삭제하고 재생성해도 데이터가 유지된다.

### 7-3-3. Spring Boot 프로젝트와 MariaDB 연동

- Spring Boot 프로젝트에 MariaDB 연동 설정을 추가하여 계산 이력을 데이터베이스에 저장할 것이다.

> `chap02_01_bootproject` 프로젝트를 참고한다.

- **주요 변경 사항**:
  1. `build.gradle`에 MariaDB 드라이버와 JPA 의존성 추가
  2. `application.yml`에 데이터베이스 연결 정보 설정
  3. `CalculationHistory` 엔티티 생성
  4. `CalculationHistoryRepository` 생성
  5. `CalculatorService`에서 계산 결과를 DB에 저장

- 프로젝트를 빌드하고 도커 이미지를 생성한다.

  ```powershell
  $ cd chap02_01_bootproject
  $ docker build -t ys0915/calc-volume:latest .
  ```

- Spring Boot 컨테이너와 MariaDB 컨테이너를 연결하여 실행한다.

  ```powershell
  # MariaDB 컨테이너가 실행중이지 않다면 실행
  $ docker run --name mariadb-persist -e MARIADB_ROOT_PASSWORD=root1234 -e MARIADB_DATABASE=calcdb -p 3310:3306 -v mariadb-volume:/var/lib/mysql -d mariadb:latest
  
  # Spring Boot 컨테이너 실행 (MariaDB와 연결)
  $ docker run --name spring-calc -p 8055:7777 --link mariadb-persist:mysql -d ys0915/calc-volume:latest
  ```

- API를 호출하여 계산을 수행하고 데이터베이스에 저장되는지 확인한다.

  ```powershell
  # POST 요청으로 계산 수행
  $ curl -X POST http://localhost:8055/plus -H "Content-Type: application/json" -d "{\"num1\":10, \"num2\":20}"
  
  # GET 요청으로 계산 이력 조회
  $ curl http://localhost:8055/history
  ```

- MariaDB에 직접 접속하여 데이터가 저장되었는지 확인한다.

  ```powershell
  $ docker exec -it mariadb-persist mariadb -u root -p
  ```

  ```sql
  USE calcdb;
  SELECT * FROM calculation_history;
  exit;
  ```

### 7-3-4. docker-compose로 전체 구성하기

- `docker-compose.yml` 파일을 작성하여 Spring Boot와 MariaDB를 함께 관리할 수 있다.

  ```yaml 
  services:
    springboot-app:
      build:
        context: ./chap02_01_bootproject
        dockerfile: Dockerfile
      image: ys0915/calc-volume:latest
      container_name: spring-calc-compose
      ports:
        - "8055:7777"
      networks:
        - calc-net
      depends_on:
        - mariadb
      restart: always
  
    mariadb:
      image: mariadb:latest
      container_name: mariadb-compose
      environment:
        - MARIADB_ROOT_PASSWORD=root1234
        - MARIADB_DATABASE=calcdb
      ports:
        - "3310:3306"
      volumes:
        - mariadb-data:/var/lib/mysql
      networks:
        - calc-net
      restart: always
  
  volumes:
    mariadb-data:
      driver: local
  
  networks:
    calc-net:
      driver: bridge
  ```

- docker-compose를 실행한다.

  ```powershell
  $ docker-compose up -d
  ```

- API를 테스트한다.

  ```powershell
  $ curl -X POST http://localhost:8055/plus -H "Content-Type: application/json" -d "{\"num1\":30, \"num2\":40}"
  $ curl http://localhost:8055/history
  ```

- 컨테이너를 종료하고 다시 시작해도 데이터가 유지되는지 확인한다.

  ```powershell
  $ docker-compose down
  $ docker-compose up -d
  $ curl http://localhost:8055/history
  ```

> docker-compose를 사용하면 볼륨과 네트워크 설정을 포함한 전체 환경을 코드로 관리할 수 있다.
