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
    const gender_option = ref();
    const honorifics_option = ref();
    const lead_status_option = ref();

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);

    // referenceable CSS attribute
    const css_class_attributes = {
        edit_attribute_area: "flex flex-col w-max h-max bg-amber-300 mx-5 px-5 py-2 my-2",

        normal_edit_attribute: "flex flex-row mb-1 items-center",
        description_edit_attribute: "flex flex-row mb-1",
        normal_label: "w-48 flex justify-end px-2 py-1 mx-1 bg-violet-500 border-2",
        text_input: "h-8 w-100 mx-1 border-2 cursor-pointer focus:cursor-text px-2 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:border-pink-500 overflow-auto text-nowrap truncate",
        text_area_input: "w-100 h-40 mx-1 cursor-pointer focus:cursor-text px-2 py-2 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-top-right bg-size-[5%_auto] bg-origin-content resize-none",
        text_area_input_short: "w-100 h-25 mx-1 cursor-pointer focus:cursor-text px-2 py-2 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-top-right bg-size-[5%_auto] bg-origin-content resize-none",
        paragraph_input: "flex w-100 h-40 mx-1 px-2 py-2 overflow-auto",
        paragraph_input_short: "flex w-100 h-20 mx-1 px-2 py-2 overflow-y-scroll",

        tooltip_show: "visible",
        tooltip_hide: "hidden",
        tooltip: "flex w-100 h-14 bg-rose-600 absolute z-2 m-1 -top-16 py-1 px-2 text-xs whitespace-pre-line",

        save_button: "hover:cursor-pointer w-5 h-5 mx-1 text-white bg-green-600 rounded-full flex justify-center items-center",
        cancel_button: "hover:cursor-pointer w-5 h-5 mx-1 text-white bg-red-700 rounded-full flex justify-center items-center",
    }

    // refferenceable input attribute
    const input_attributes = {
        text: "text",
        textarea: "textarea",
        none: "none",
        paragraph: "paragraph",
        fixed_select: "fixed_select",

        name_pattern: "[A-Z]{1}([a-zA-Z]*)$",
        phone_pattern: "[0-9]{8,20}$",
        email_pattern: "([a-z,0-9]{2,})@([a-z,0-9]{2,}).([a-z]{2,})$",

        trait_text: "text",
        trait_select: "select",

        name_format_wrong: "Bad name format, please try again. \n(Name must start with capital letter, and does not include numbers or special character)",
    }

    // ref to store the display attribute
    const edit_attribute_left = {
        last_name: {
            name: "Last name",
            correspond: "last_name",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.text,
            trait: input_attributes.trait_text,
            pattern: input_attributes.name_pattern,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        middle_name: {
            name: "Middle name",
            correspond: "middle_name",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.text,
            trait: input_attributes.trait_text,
            pattern: input_attributes.name_pattern,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        first_name: {
            name: "First name",
            correspond: "first_name",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.text,
            trait: input_attributes.trait_text,
            pattern: input_attributes.name_pattern,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        gender: {
            name: "Gender",
            correspond: "gender",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(gender_option),
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        honorifics: {
            name: "Honorifics",
            correspond: "honorifics",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(honorifics_option),
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        phone_number: {
            name: "Phone number",
            correspond: "phone_number",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.text,
            trait: input_attributes.trait_text,
            pattern: input_attributes.phone_pattern,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        email_address: {
            name: "Email address",
            correspond: "email_address",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.text,
            trait: input_attributes.trait_text,
            pattern: input_attributes.email_pattern,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        individual_description: {
            name: "Individual description",
            correspond: "individual_description",
            table: "individual.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_area_input,
            input: input_attributes.textarea,
            trait: input_attributes.trait_text,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        }
    }

    const edit_attribute_right = {
        lead_status: {
            name: "Lead status",
            correspond: "lead_status",
            table: "lead_individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(lead_status_option),
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        lead_conversion_message: {
            name: "Conversion note",
            correspond: "conversion_message",
            table: "conversion_history.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_area_input_short,
            input: input_attributes.textarea,
            trait: input_attributes.trait_text,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        company: {
            name: "Company",
            correspond: "company_name",
            table: "company.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.paragraph,
            trait: input_attributes.trait_select,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        company_address: {
            name: "Company address",
            correspond: "company_address",
            table: "company.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.paragraph_input_short,
            input: input_attributes.paragraph,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        company_description: {
            name: "Company description",
            correspond: "company_description",
            table: "company.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.paragraph_input,
            input: input_attributes.paragraph,
            value: ref(),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        }
    }

    const overview_attribute = {
        lead_owner: {
            name: "Lead owner",
            correspond: "lead_owner_name",
            table: "crm_user.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            value: ref(),
            hover: ref(false),
        },
        lead_owner_id: {
            name: "Lead owner ID",
            correspond: "lead_owner_user_id",
            table: "lead_individual.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            value: ref(),
            hover: ref(false),
        },
        lead_status: {
            name: "Lead status",
            correspond: "lead_status",
            table: "lead_individual.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            value: ref(),
            hover: ref(false),
        },
        registered_date: {
            name: "Registered date",
            correspond: "registered_date",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            input: input_attributes.none,
            value: ref(),
            hover: ref(false),
        },
        created_by: {
            name: "Created by",
            correspond: "created_by_name",
            table: "crm_user.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            input: input_attributes.none,
            value: ref(),
            hover: ref(false),
        }
    }

    // retrieve the lead to edit
    const get_lead_detail = async (attribute) => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {requirement: JSON.stringify(["individual_id:" + props.individual_id]), hard_requirement: true});
            // check if the retrieve is success (by checking if the object has key)
            success_response.value = (Object.keys(response.value.data)).length > 0;

            if (success_response.value && attribute == null){
                for (const key in edit_attribute_left)
                    edit_attribute_left[key]['value'].value = response.value.data[0][edit_attribute_left[key]['correspond']];
                for (const key in edit_attribute_right)
                    edit_attribute_right[key]['value'].value = response.value.data[0][edit_attribute_right[key]['correspond']];
                    for (const key in overview_attribute)
                    overview_attribute[key]['value'].value = response.value.data[0][overview_attribute[key]['correspond']];
            } else if (success_response.value){
                attribute['value']['value'] = response.value.data[0][attribute['correspond']];
            }
        } catch (error){
            alert(error);
        }
    }

    // get select option of lead status
    const get_lead_status_option = async () => {
        try {
            const lead_status_option_response = await axios.post("../backend/retrieve_lead_status_option_api.php", {data: "option"});
            // it should be an object (array), keys are index
            lead_status_option['value'] = lead_status_option_response.data;
        } catch (error){
            alert(error);
        }
    }

    // get select option of gender
    const get_gender_option = async () => {
        try {
            const lead_status_option_response = await axios.post("../backend/retrieve_gender_option_api.php", {data: "option"});
            // it should be an object (array), keys are index
            gender_option['value'] = lead_status_option_response.data;
        } catch (error){
            alert(error);
        }
    }

    // get select option of honorifics
    const get_honorifics_option = async () => {
        try {
            const lead_status_option_response = await axios.post("../backend/retrieve_honorifics_option_api.php", {data: "option"});
            // it should be an object (array), keys are index
            honorifics_option['value'] = lead_status_option_response.data;
        } catch (error){
            alert(error);
        }
    }

    // detect changes
    const select_changed = (attribute) => {
        if (attribute != null){
            attribute['changed']['value'] = true;
            if (attribute['correspond'] == "lead_status"){
                edit_attribute_right['lead_conversion_message']['changed'] = true;
            }
        }
    }

    // input validation & update
    const validate_update_data = async (attribute) => {
        if (attribute['trait'] == "text"){
            const reg_exp = new RegExp(attribute['pattern']);
            if (reg_exp.test(attribute['value']['value'])){
                attribute['has_error']['value'] = false;
                const edit_response = await axios.post(
                    "../backend/edit_lead_api.php",
                    {
                        individual_id: props.individual_id,
                        update_table: (attribute['table']).slice(0, -1),
                        update_attribute: (attribute['correspond']),
                        update_value: "'" + attribute['value']['value'] + "'"
                    }
                );
                if (edit_response.status == 204){
                    alert("success");
                    get_lead_detail(attribute);
                    attribute['changed']['value'] = false;
                }
            } else {
                attribute['has_error']['value'] = true;
                attribute['tooltip_visible']['value'] = true;
                
                if (attribute['pattern'] == input_attributes.name_pattern){
                    attribute['tooltip_message']['value'] = input_attributes.name_format_wrong;
                }
            }
        } else if (attribute['trait'] == "select"){
            
        }
    }

    // cancel changes
    const cancel_changes = (attribute) => {
        attribute['changed']['value'] = false;
        attribute['has_error']['value'] = false;
        attribute['value']['value'] = response.value.data[0][attribute['correspond']];

        if (attribute['correspond'] == "lead_status"){
            edit_attribute_right['lead_conversion_message']['changed'] = false;
            edit_attribute_right['lead_conversion_message']['value'] = "";
        }
    }

    // initialize / update to get data
    const initialize = async () => {
        get_lead_detail();
        get_lead_status_option();
        get_gender_option();
        get_honorifics_option();
    }

    initialize();
</script>

<template>
    <div>{{ success_response }}: {{ response.data[0] }} </div>

    <div class="flex flex-col w-screen min-w-max overflow-auto justify-center items-center bg-green-500">

        <!-- basic display part -->
        <div class="flex flex-col min-w-300 overflow-auto px-20 py-10">
            <div class="flex flex-row w-full bg-rose-700" v-for="value in overview_attribute">
                <div>{{ value['name'] }}</div>
                <div>{{ value['value'].value }}</div>
            </div>
        </div>

        <!-- edit part -->
         <div class="flex w-full bg-red-600 justify-center">
            <div class="flex flex-row min-w-max w-max m-4 bg-red-800 justify-center">
                <!-- data at left side -->
                <div :class="css_class_attributes.edit_attribute_area">
                    <div :class="value['class']" v-for="value in edit_attribute_left" :key="value">
                        <label v-if="value['correspond'] != 'conversion_message' || (value['correspond'] == 'conversion_message' && value['changed'] == true)" :for="value['correspond'] + '_input'" :class="value['name_class']"><div>{{ value['name'] }}</div></label>
                        <!-- the input field -->
                        <div class="relative">
                            <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" :pattern="value['pattern']" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="value['input_class']" v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                            <textarea @input="value['changed'].value = true" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed'] == true))" :class="value['input_class']" v-model="value['value'].value"></textarea>
                            <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']">{{ value['value'].value }}</div>
                            <select @input="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']">
                                <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
                            </select>
                            <!-- tooltip content-->
                            <div v-if="value['has_error'].value" :class="[value['tooltip_visible'].value, css_class_attributes.tooltip]">{{ value['tooltip_message'].value }}</div>
                        </div>
                        <div v-if="value['changed'].value && value['correspond'] != 'conversion_message'" class="flex flex-row h-max">
                            <button @click="validate_update_data(value)" :class="css_class_attributes.save_button">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="size-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
                                </svg>
                            </button>
                            <button @click="cancel_changes(value)" :class="css_class_attributes.cancel_button">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="size-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- data at right side -->
                <div :class="css_class_attributes.edit_attribute_area">
                    <div :class="value['class']" v-for="value in edit_attribute_right" :key="value">
                        <label v-if="value['correspond'] != 'conversion_message' || (value['correspond'] == 'conversion_message' && value['changed'] == true)" :for="value['correspond'] + '_input'" :class="value['name_class']"><div>{{ value['name'] }}</div></label>
                        <!-- the input field -->
                        <div class="relative">
                            <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" :pattern="value['pattern']" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="value['input_class']" v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                            <textarea @input="value['changed'].value = true" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed'] == true))" :class="value['input_class']" v-model="value['value'].value"></textarea>
                            <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']">{{ value['value'].value }}</div>
                            <select @input="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']">
                                <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
                            </select>
                            <!-- tooltip content-->
                            <div v-if="value['has_error'].value" :class="[value['tooltip_visible'].value, css_class_attributes.tooltip]">{{ value['tooltip_message'].value }}</div>
                        </div>
                        <div v-if="value['changed'].value && value['correspond'] != 'conversion_message'" class="flex flex-row h-max">
                            <button @click="validate_update_data(value)" :class="css_class_attributes.save_button">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="size-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
                                </svg>
                            </button>
                            <button @click="cancel_changes(value)" :class="css_class_attributes.cancel_button">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="size-4">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!--  -->
    </div>
</template>

<style>

</style>