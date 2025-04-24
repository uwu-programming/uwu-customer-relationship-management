<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        individual_id: String // for accessing specific individual
    });

    // store the response from API request
    const response = ref();

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);

    // retrieve the lead to edit
    const get_lead_detail = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {requirement: JSON.stringify(["individual.individual_id:" + props.individual_id]), hard_requirement: true});
            // check if the retrieve is success (by checking if the object has key)
            success_response.value = (Object.keys(response.value.data)).length > 0;
        } catch (error){
            alert(error);
        }
    }

    get_lead_detail();
</script>

<template>
    
</template>