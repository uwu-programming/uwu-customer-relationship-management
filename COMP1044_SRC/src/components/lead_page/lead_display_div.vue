<script setup>
    import axios from "axios";
    import {ref} from "vue";

    const response = ref(); // lead data

    // referenceable CSS attribute
    const css_class_attributes = {
        individual_id: "w-32 px-4 text-center truncate ",
        name: "w-40 px-4 text-center truncate ",
        honorifics: "w-27 text-center px-4 truncate ",
        gender: "w-30 px-4 text-center truncate ",
        country: "w-40 px-4 text-center truncate ",
        company: "w-50 px-4 text-center truncate ",
        description: "w-80 px-4 text-center truncate ",
        date: "w-50 px-4 text-center truncate ",

        title_bar: "border-r-1 flex flex-row w-max py-1 ",
        title_bar_button: "mx-2 ",

        display_span: "py-2 "
    }

    // the JS object for all the displayable attributes from database
    // used for manipulating which attribute to display, the CSS, etc.
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
        phone_number: {
            name: "Phone number",
            correspond: "phone_number",
            class: css_class_attributes.name,
            display: true
        },
        email_address: {
            name: "Email address",
            correspond: "email_address",
            class: css_class_attributes.company,
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

    // retrieve all data from TABLE individual JOIN company
    const retrieve_all = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {sort: false});
        } catch (error){
            alert(error);
        }
    };

    // sort the data by order of an attribute
    const sort_data = async (sort_attribute, sort_by) => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {sort: true, sort_attribute: sort_attribute, sort_by: sort_by});
        } catch (error){
            alert(error);
        }
    }

    // display the inline-block that enable sorting
    const display_sort_diplay = (id) => {
        const sort_display = document.getElementById(id + '_sort_display');
        sort_display.className = "block absolute";
    }

    retrieve_all();
</script>

<template>
    <div class="flex flex-col h-120 w-180 m-2 rounded-2xl border-1 overflow-auto">
        <div class="flex flex-row w-max bg-fuchsia-500 border-b-2">
            <div class="flex flex-row w-max" v-for="value in lead_display_attributes" :key="value">
                <div v-if="value['display'] || true" v-bind:class="(value['class'] + css_class_attributes.title_bar)">
                    {{ value['name'] }}
                    <button @click="display_sort_diplay(value['correspond'])" v-bind:ref="value['correspond'] + '_sort_button'" v-bind:id="value['correspond'] + '_sort_button'" class="hover:bg-gray-300/80 rounded-full mx-2 h-7 w-7 flex justify-center items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
                        </svg>
                    </button>
                    <div v-bind:ref="value['correspond'] + '_sort_display'" v-bind:id="value['correspond'] + '_sort_display'" class="absolute hidden">
                        <button class="block">Ascending</button>
                        <button class="block">Descending</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="flex flex-col w-max overflow-y-auto">
            <button class="w-max bg-sky-500 hover:bg-cyan-300 flex flex-row justify-between border-b-gray-300/80 border-b-1" v-if="response.status==200" v-for="response_value in response.data" :key="response_value" v-bind:id="response_value.individual_id">
                <div class="w-max flex" v-for="value in lead_display_attributes" :key="value">   
                    <span v-if="value['display'] || true" v-bind:class="value['class'] + css_class_attributes.display_span">{{ response_value[value['correspond']] }}</span>
                </div>
            </button>
        </div>
    </div>
</template>