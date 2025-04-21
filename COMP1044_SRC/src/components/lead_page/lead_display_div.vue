<script setup>
    import axios from "axios";
    import {ref} from "vue";

    const response = ref();

    const retrieve_all = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_individual_api.php");
        } catch (error){
            alert(error);
        }
    };

    retrieve_all();
</script>

<template>
    <div class="flex flex-col overflow-y-auto h-3/4">
        <button class="bg-gray-300 h-10 w-50 hover:bg-cyan-300" v-if="response.status==200" v-for="value in response.data" :key="value">{{ value.honorifics }} {{ value.last_name }}</button>
    </div>
</template>