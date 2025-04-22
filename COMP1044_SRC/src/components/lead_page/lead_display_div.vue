<script setup>
    import axios from "axios";
    import {ref} from "vue";

    const response = ref();

    const css_class_attributes = {
        name: "w-36 bg-amber-400 px-4 py-2 text-center truncate"
    }

    const lead_display_attributes = {
        individual_id: {
            class: ""
        },
        last_name: {
            class: css_class_attributes.name
        },
        middle_name: {
            class: ""
        },
        first_name: {
            class: css_class_attributes.name
        },
        gender: {
            class: ""
        },
        honorifics: {
            class: "w-27 py-2 text-center px-4 truncate"
        },
        country: {
            class: ""
        },
        company_name: {
            class: "w-81 px-4 py-2 text-center truncate"
        },
        company_description: {
            class: ""
        },
        individual_description: {
            class: ""
        },
        registered_date: {
            class: ""
        }
    };

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
    <div class="flex flex-col h-120 w-180 m-2 rounded-2xl border-1 overflow-auto">
        <div class="flex flex-row w-max bg-fuchsia-500 border-b-2">
            <div class="w-27 px-4 py-2 text-center border-r-1 border-black/80 truncate">Honorifics</div>
            <div class="w-36 px-4 py-2 text-center border-r-1 border-black/80 truncate" v-for="value in lead_display_attributes" :key="value">{{ value }}</div>
            <div class="w-81 px-4 py-2 text-center truncate">Company name</div>
        </div>
        <div class="flex flex-col w-max overflow-y-auto">
            <button class="bg-sky-500 hover:bg-cyan-300" v-if="response.status==200" v-for="value in response.data" :key="value" v-bind:id="value.individual_id">
                <div class="flex flex-row justify-between border-b-gray-300/80 border-b-1">   
                    <span class="w-27 py-2 text-center px-4 truncate">{{ value.honorifics }}</span>
                    <span class="w-36 bg-amber-400 px-4 py-2 text-center truncate">{{ value.last_name }}</span>
                    <span class="w-36 bg-amber-500 px-4 py-2 text-center truncate">{{ value.first_name }}</span>
                    <span class="w-81 px-4 py-2 text-center truncate">{{ value.company_name }}</span>
                </div>
            </button>
        </div>
    </div>
</template>