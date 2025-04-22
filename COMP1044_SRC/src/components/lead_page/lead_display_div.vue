<script setup>
    import axios from "axios";
    import {ref} from "vue";

    const response = ref();

    const css_class_attributes = {
        individual_id: "w-32 px-4 py-2 text-center truncate border-r-1",
        name: "w-40 px-4 py-2 text-center truncate border-r-1",
        honorifics: "w-27 py-2 text-center px-4 truncate border-r-1",
        gender: "w-30 px-4 py-2 text-center truncate border-r-1",
        country: "w-30 px-4 py-2 text-center truncate border-r-1",
        company: "w-50 px-4 py-2 text-center truncate border-r-1",
        description: "w-80 px-4 py-2 text-center truncate border-r-1",
        date: "w-40 px-4 py-2 text-center truncate border-r-1"
    }

    const lead_display_attributes = {
        individual_id: {
            name: "Individual ID",
            correspond: "individual_id",
            class: css_class_attributes.individual_id,
            display: false
        },
        honorifics: {
            name: "Honorifics",
            correspond: "honorifics",
            class: css_class_attributes.honorifics,
            display: true
        },
        last_name: {
            name: "Last name",
            correspond: "last_name",
            class: css_class_attributes.name,
            display: true
        },
        middle_name: {
            name: "Middle name",
            correspond: "middle_name",
            class: css_class_attributes.name,
            display: false
        },
        first_name: {
            name: "First name",
            correspond: "first_name",
            class: css_class_attributes.name,
            display: true
        },
        gender: {
            name: "Gender",
            correspond: "gender",
            class: css_class_attributes.gender,
            display: false
        },
        country: {
            name: "Country",
            correspond: "country_name",
            class: css_class_attributes.country,
            display: false
        },
        company_name: {
            name: "Company name",
            correspond: "company_name",
            class: css_class_attributes.company,
            display: true
        },
        company_address: {
            name: "Company address",
            correspond: "company_address",
            class: css_class_attributes.description,
            display: false
        },
        company_description: {
            name: "Company description",
            correspond: "company_description",
            class: css_class_attributes.description,
            display: false
        },
        individual_description: {
            name: "Individual description",
            correspond: "individual_description",
            class: css_class_attributes.description,
            display: false
        },
        registered_date: {
            name: "Registered date",
            correspond: "registered_date",
            class: css_class_attributes.date,
            display: false
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
            <div v-for="value in lead_display_attributes" :key="value">
                <div v-if="value['display'] || true" v-bind:class="value['class']">{{ value['name'] }}</div>
            </div>
        </div>
        <div class="flex flex-col w-max overflow-y-auto">
            <button class="w-max bg-sky-500 hover:bg-cyan-300 flex flex-row justify-between border-b-gray-300/80 border-b-1" v-if="response.status==200" v-for="response_value in response.data" :key="response_value" v-bind:id="response_value.individual_id">
                <div class="w-max flex" v-for="value in lead_display_attributes" :key="value">   
                    <span v-if="value['display'] || true" v-bind:class="value['class']">{{ response_value[value['correspond']] }}</span>
                </div>
            </button>
        </div>
    </div>
</template>