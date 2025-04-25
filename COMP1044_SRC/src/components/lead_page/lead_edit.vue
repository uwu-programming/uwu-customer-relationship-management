<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        individual_id: String // for accessing specific individual
    });

    // store the response from API request
    const response = ref();
    const user = ref();

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);

    // referenceable CSS attribute
    const css_class_attributes = {
        normal_edit_attribute: "flex flex-row",
        description_edit_attribute: "flex flex-col"
    }

    // refferenceable input attribute
    const input_attributes = {
        text: "text",
        textarea: "textarea",
        none: "none"
    }

    // ref to store the display attribute
    const edit_attribute_left = {
        last_name: {
            name: "Last name",
            correspond: "last_name",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        middle_name: {
            name: "Middle name",
            correspond: "middle_name",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        first_name: {
            name: "First name",
            correspond: "first_name",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        phone_number: {
            name: "Phone number",
            correspond: "phone_number",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        email_address: {
            name: "Email address",
            correspond: "email_address",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        individual_description: {
            name: "Individual description",
            correspond: "individual_description",
            table: "individual.",
            class: css_class_attributes.description_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.textarea,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        registered_date: {
            name: "Registered date",
            correspond: "registered_date",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.none,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        }
    }

    const edit_attribute_right = {
        lead_status: {
            name: "Lead status",
            correspond: "lead_status",
            table: "lead_individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: "",
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        company: {
            name: "Company",
            correspond: "company_name",
            table: "company.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        company_address: {
            name: "Company address",
            correspond: "company_address",
            table: "company.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.text,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        },
        company_description: {
            name: "Company description",
            correspond: "company_description",
            table: "company.",
            class: css_class_attributes.description_edit_attribute,
            name_class: "",
            input_class: "",
            input: input_attributes.textarea,
            value: ref(),
            hover: ref(false),
            changed: ref(false)
        }
    }

    // retrieve the lead to edit
    const get_lead_detail = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {requirement: JSON.stringify(["individual.individual_id:" + props.individual_id]), hard_requirement: true});
            // check if the retrieve is success (by checking if the object has key)
            success_response.value = (Object.keys(response.value.data)).length > 0;

            if (success_response.value){
                for (const key in edit_attribute_left)
                    edit_attribute_left[key]['value'].value = response.value.data[0][edit_attribute_left[key]['correspond']];
                for (const key in edit_attribute_right)
                    edit_attribute_right[key]['value'].value = response.value.data[0][edit_attribute_right[key]['correspond']];
            }
        } catch (error){
            alert(error);
        }
    }

    get_lead_detail();
</script>

<template>
    <div>{{ success_response }}: {{ response.data[0] }} </div>

    <div class="flex flex-row w-screen">
        <!-- data at left side -->
        <div class="flex flex-col w-1/2">
            <div :class="value['class']" v-for="value in edit_attribute_left" :key="value">
                <div class="">{{ value['name'] }}</div>
                <!-- the input field -->
                <input v-if="value['input'] == 'text'" class="bg-rose-400 w-40" v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                <textarea v-else-if="value['input'] == 'textarea'" v-model="value['value'].value"></textarea>
                <span v-else>{{ value['value'] }}</span>
                <!-- the label -->
                <label v-if="value['input'] == 'text'" :for="value['correspond'] + '_input'" class="flex flex-row relative right-40"><div class="bg-violet-700/60 h-6 w-40 px-2 bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[auto_75%] bg-origin-content"></div></label>
            </div>
        </div>

        <!-- data at right side -->
        <div class="flex flex-col w-1/2">
            <div :class="value['class']" v-for="value in edit_attribute_right" :key="value">
                <div class="">{{ value['name'] }}</div>
                <!-- the input field -->
                <input v-if="value['input'] == 'text'" class="bg-rose-400 w-40" v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                <textarea v-else-if="value['input'] == 'textarea'" v-model="value['value'].value"></textarea>
                <span v-else>{{ value['value'] }}</span>
                <!-- the label -->
                <label v-if="value['input'] == 'text'" :for="value['correspond'] + '_input'" class="flex flex-row relative right-40"><div class="bg-violet-700/60 h-6 w-40 px-2 bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[auto_75%] bg-origin-content"></div></label>
            </div>
        </div>
    </div>
</template>

<style>

</style>