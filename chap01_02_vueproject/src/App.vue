<template>
  <div class="plus">
    <h1>덧셈 기능 만들기</h1>
    <label>num1: </label><input type="text" v-model="num1">&nbsp;
    <label>num2: </label><input type="text" v-model="num2">&nbsp;
    <button @click="sendPlus">더하기</button>
    <button @click="sendPlus2">post더하기</button>
    <hr>
    <p>{{ num1 }} + {{ num2 }} = {{ sum }}</p>
  </div>
</template>

<script setup>
  import {ref} from 'vue';

  const num1 = ref(0);
  const num2 = ref(0);
  const sum = ref(0);

  const sendPlus = async() => {
    /* 1. 백엔드에서 CORS, 프론트에서 X */
    // const response = await fetch(`http://localhost:7777/plus?num1=${num1.value}&num2=${num2.value}`);
    /* 2. 백엔드에서 CORS, 프론트에서 x(백엔드만 컨테이너화) */
    // const response = await fetch(`http://localhost:8888/plus?num1=${num1.value}&num2=${num2.value}`);
    /* 2. 백엔드에서  x, 프론트에서 CORS(백엔드만 컨테이너화) */
    // const response = await fetch(`http://localhost:5173/api/plus?num1=${num1.value}&num2=${num2.value}`);

    /* 이후 코드는 post 요청에 데이터는 request body를 활용(백엔드도 수정) */
    // const response = await fetch(`http://localhost:5173/api/plus`, {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json;charset=utf-8;'
    //   },
    //   body: JSON.stringify({num1: num1.value, num2: num2.value})
    // })

    /* 4. 백엔드에서 O, 프론트에서 X(프론트와 백엔드 모두 컨테이너화) */
    // const response = await fetch(`http://localhost:8055/plus`, {
    //       method: 'POST',
    //       headers: {
    //         'Content-Type': 'application/json;charset=utf-8;'
    //       },
    //       body: JSON.stringify({num1: num1.value, num2: num2.value})
    //     })

    // /* 5. 백엔드에서 x, 프론트에서 CORS(프론트와 백엔드 모두 컨테이너화(docker-copose, bridge network활용)) */
    // const response = await fetch(`http://localhost:8011/api/plus`, {
    //       method: 'POST',
    //       headers: {
    //         'Content-Type': 'application/json;charset=utf-8;'
    //       },
    //       body: JSON.stringify({num1: num1.value, num2: num2.value})
    //     })

    // /* 6. 백엔드에서 CORS, 프론트에서 x(k8s nodeport 적용(인그래스 사용 전) ) */
    // const response = await fetch(`http://localhost:30001/plus`, {
    //       method: 'POST',
    //       headers: {
    //         'Content-Type': 'application/json;charset=utf-8;'
    //       },
    //       body: JSON.stringify({num1: num1.value, num2: num2.value})
    //     })

        

    /* 7. 백엔드에서 x, 프론트에서 x(k8s ingress를 활용한 방식 ) */
    const response = await fetch(`http://localhost:80/boot/plus`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json;charset=utf-8;'
          },
          body: JSON.stringify({num1: num1.value, num2: num2.value})
        })

    console.log(response);
    const data = await response.json();
    console.log(data);
    sum.value = data.sum;

  }

  const sendPlus2 = async() => {
    const response = await fetch(`http://localhost:7777/plus`,
      {
        method :"POST",
        body : '{"num1" : 1, "num2" : 2}',
        headers: {
          "Content-Type": "application/json",
          // 'Content-Type': 'application/x-www-form-urlencoded',
    }

      }
    );
    console.log(response);
    const data = await response.json();
    console.log(data);
    sum.value = data.sum;

  }
</script>

<style scoped>
  .plus{
    text-align: center;
  }
</style>