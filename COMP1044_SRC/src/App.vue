<script>
  export default{
    data(){
      return{
        array: [1, 2, 3]
      };
    },
    methods: {
      uwu(){
        alert("uwu");
      }
    }
  }
</script>

<template>
  <h1 class="text-2xl">Hello world</h1>
  <span v-for = "value in array" :key = "value">{{ value }} <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"> ??? </button> </span>
  <button v-on:click = "uwu" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full">uwu</button>
</template>