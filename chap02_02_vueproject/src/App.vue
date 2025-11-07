<template>
  <div class="plus">
      <h1>덧셈 기능 만들기 (with Volume & DB)</h1>
      <label>num: 1</label><input type="text" v-model="num1">&nbsp;
      <label>num: 2</label><input type="text" v-model="num2">&nbsp;
      <button @click="sendPlus">더하기</button>
      <button @click="getHistory" style="margin-left: 10px;">이력 조회</button>
      <hr>
      <p>{{ num1 }} + {{ num2 }} = {{ sum }}</p>
      
      <div v-if="historyList.length > 0" class="history">
          <h3>계산 이력</h3>
          <table>
              <thead>
                  <tr>
                      <th>번호</th>
                      <th>숫자1</th>
                      <th>숫자2</th>
                      <th>결과</th>
                      <th>계산일시</th>
                  </tr>
              </thead>
              <tbody>
                  <tr v-for="item in historyList" :key="item.id">
                      <td>{{ item.id }}</td>
                      <td>{{ item.num1 }}</td>
                      <td>{{ item.num2 }}</td>
                      <td>{{ item.result }}</td>
                      <td>{{ formatDate(item.createdAt) }}</td>
                  </tr>
              </tbody>
          </table>
      </div>
  </div>
</template>
<script setup>
  import {ref} from 'vue';

  const num1 = ref(0);
  const num2 = ref(0);
  const sum = ref(0);
  const historyList = ref([]);   // 추가 된 반응형 변수

  const sendPlus = async () => {

    /* 1. 백엔드에서 CORS, 프론트에서 X */
    // const response = await fetch(`http://localhost:7777/plus?num1=${num1.value}&num2=${num2.value}`);

    /* 2. 백엔드에서 CORS, 프론트에서 X(백엔드만 컨테이너화) */
    // const response = await fetch(`http://localhost:8888/plus?num1=${num1.value}&num2=${num2.value}`);

    /* 3. 백엔드에서 X, 프론트에서 CORS(백엔드만 컨테이너화) */
    // const response = await fetch(`http://localhost:5173/api/plus?num1=${num1.value}&num2=${num2.value}`);
    
    /* 이후 코드는 post 요청에 데이터는 request body를 활용(백엔드도 수정) */
    // const response = await fetch(`http://localhost:5173/api/plus`, {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json;charset=utf-8;'
    //   },
    //   body: JSON.stringify({num1: num1.value, num2: num2.value})
    // })

    /* 4. 백엔드에서 CORS, 프론트에서 X(프론트와 백엔드 모두 컨테이너화) */
    // const response = await fetch(`http://localhost:8055/plus`, {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json;charset=utf-8;'
    //   },
    //   body: JSON.stringify({num1: num1.value, num2: num2.value})
    // })

    // /* 5. 백엔드에서 X, 프론트에서 CORS(프론트와 백엔드 모두 컨테이너화(docker-compose, bridge network 활용)) */
    // const response = await fetch(`http://localhost:8011/api/plus`, {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json;charset=utf-8;'
    //   },
    //   body: JSON.stringify({num1: num1.value, num2: num2.value})
    // })

    // /* 6. 백엔드에서 CORS, 프론트에서 X(Vue + Spring Boot(JPA) + MariaDB(Docker-Compose)) */
    // const response = await fetch(`http://localhost:8055/plus`, {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json;charset=utf-8;'
    //   },
    //   body: JSON.stringify({num1: num1.value, num2: num2.value})
    // })
    

    /* 7. 백엔드에서 x, 프론트에서 X(Vue + Spring Boot(JPA) + MariaDB(k8s)) */
    const response = await fetch(`http://localhost/boot/plus`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8;'
      },
      body: JSON.stringify({num1: num1.value, num2: num2.value})
    })
    
    
    
    const data = await response.json();
    sum.value = data.sum;

    await getHistory();
  }

  const getHistory = async() => {
      try {
        //   const response = await fetch(`http://localhost:8055/history`);  // Docker-Compose용
          const response = await fetch(`http://localhost/boot/history`);  // k8s ingress용
          const data = await response.json();
          console.log('history:', data);
          historyList.value = data;
      } catch (error) {
          console.error('이력 조회 실패:', error);
      }
  }

  const formatDate = (dateString) => {
      const date = new Date(dateString);
      return date.toLocaleString('ko-KR');
  }
</script>

<style scoped>
  .plus {
      text-align: center;
      padding: 20px;
  }

  .history {
      margin-top: 30px;
      padding: 20px;
      background-color: #f5f5f5;
      border-radius: 8px;
  }

  table {
      margin: 0 auto;
      border-collapse: collapse;
      width: 80%;
      max-width: 800px;
      background-color: white;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }

  th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: center;
  }

  th {
      background-color: #4CAF50;
      color: white;
      font-weight: bold;
  }

  tr:nth-child(even) {
      background-color: #f9f9f9;
  }

  tr:hover {
      background-color: #f0f0f0;
  }

  button {
      padding: 8px 16px;
      font-size: 14px;
      cursor: pointer;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      transition: background-color 0.3s;
  }

  button:hover {
      background-color: #45a049;
  }

  button:active {
      background-color: #3d8b40;
  }
</style>