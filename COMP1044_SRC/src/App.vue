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
  <h1>Hello world</h1>
  <span v-for = "value in array" :key = "value">{{ value }} <button> ??? </button> </span>
  <button v-on:click = "uwu">uwu</button>
</template>