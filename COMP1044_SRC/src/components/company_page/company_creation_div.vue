<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        individual_id: String // for accessing specific individual
    });

    // new user id
    const new_user_id = ref("");

    // current crm user
    const current_crm_user = ref("");
    const current_crm_user_role = ref("");

    // store the response from API request
    const response = ref("");
    const user = ref("");
    const gender_option = ref("");
    const honorifics_option = ref("");
    const country_option = ref("");
    const lead_status_option = ref("");
    const assign_to_user_option = ref("");
    const company_option = ref("");
    const relationship_option = ref("");
    const chosen_company_id = ref("");
    const conversion_history_response = ref("");
    const role_option = ref("");

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);
    const conversion_history_exist = ref(false);

    // check if delete is activated
    const create_prompt = ref(false);
    const create_success_prompt = ref(false);
    const success_operation_prompt = ref(false);

    // check which content to load
    const information_content = ref(true);
    const conversion_history_content = ref(false);

    // referenceable CSS attribute
    const css_class_attributes = {
        edit_attribute_area: "flex flex-col w-max h-max mx-5 px-5 py-2 my-2",

        normal_edit_attribute: "flex flex-row mb-4",
        description_edit_attribute: "flex flex-row mb-4",
        search_select_edit_attribute: "flex flex-row mb-4",
        normal_label: "w-48 flex justify-end px-2 py-1 mx-1 border-b-2 border-pink-700 font-bold",
        text_input: "h-8 w-100 mx-3 bg-white rounded-md border-pink-700 border-2 cursor-pointer focus:bg-gray-100 focus:cursor-text focus:shadow-pink-500/50 shadow-xl px-2 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        text_area_input: "focus:shadow-pink-500/50 shadow-xl w-100 h-40 mx-3 border-2 border-pink-700 focus:bg-gray-100 rounded-sm bg-white cursor-pointer focus:cursor-text px-2 py-1 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-top-right bg-size-[5%_auto] bg-origin-content resize-none",
        text_area_input_short: "focus:shadow-pink-500/50 shadow-xl w-100 h-25 mx-3 border-2 border-pink-700 focus:bg-gray-100 rounded-sm bg-white cursor-pointer focus:cursor-text px-2 py-1 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-top-right bg-size-[5%_auto] bg-origin-content resize-none",
        select_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-md cursor-pointer px-2 pr-5 hover:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate shadow-xl",
        paragraph_input: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-40 mx-3 px-2 py-1 overflow-auto border-2 focus:bg-gray-100 border-pink-700 rounded-md bg-white shadow-xl",
        paragraph_input_short: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-20 mx-3 px-2 py-1 overflow-y-scroll focus:bg-gray-100 border-2 border-pink-700 rounded-sm bg-white",
        variable_select_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-sm cursor-pointer px-2 pr-5 hover:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        option_input: "",
        search_input: "focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-8 w-100 mx-3 mb-2 bg-white rounded-full border-2 border-pink-700 cursor-pointer focus:cursor-text px-2 hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",

        error_input: "shadow-red-600",

        tooltip_show: "visible",
        tooltip_hide: "hidden",
        tooltip: "text-white flex w-100 h-14 bg-rose-700 border-2 border-rose-900 absolute z-2 m-1 -top-16 left-2 py-1 px-2 text-xs whitespace-pre-line rounded-sm",

        save_button: "hover:cursor-pointer w-5 h-5 m-1 text-white bg-green-600 rounded-full flex justify-center items-center",
        cancel_button: "hover:cursor-pointer w-5 h-5 m-1 text-white bg-red-700 rounded-full flex justify-center items-center",
    }

    // refferenceable input attribute
    const input_attributes = {
        text: "text",
        textarea: "textarea",
        none: "none",
        paragraph: "paragraph",
        fixed_select: "fixed_select",
        variable_select: "variable_select",


        name_pattern: "([a-zA-Z])([a-zA-Z ]*)([a-zA-Z]+)$",
        phone_pattern: "[0-9]{8,20}$",
        email_pattern: "([a-z,0-9]{2,})@([a-z,0-9]{2,}).([a-z]{2,})$",
        password_pattern: "([a-zA-Z!@#$%^&\*1-9])([a-zA-Z!@#$%^&\*1-9]*)([a-zA-Z!@#$%^&\*1-9]+)$",

        trait_text: "text",
        trait_select: "select",

        name_format_wrong: "Bad name format, please try again. \n(Name must start with capital letter, and does not include numbers or special character)",
    }

    // ref to store the display attribute
    const edit_attribute_left = {
        company_name: {
            name: "Company name",
            correspond: "company_name",
            table: "company.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_input,
            input: input_attributes.text,
            trait: input_attributes.trait_text,
            pattern: input_attributes.name_pattern,
            value: ref(""),
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
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_area_input_short,
            input: input_attributes.textarea,
            trait: input_attributes.trait_text,
            option_list: ref(role_option),
            value: ref(""),
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
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_area_input,
            input: input_attributes.textarea,
            trait: input_attributes.trait_text,
            option_list: ref(role_option),
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
    }

    // get current crm user
    const get_current_crm_user = async () => {
        try {
            const get_current_crm_user_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user['value'] = get_current_crm_user_response['data']['user_id'];
        } catch(error) {
            alert(error);
        }
    }

    // get current crm user role
    const get_current_crm_user_role = async () => {
        try {
            const get_current_crm_user_role_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user_role['value'] = get_current_crm_user_role_response['data']['user_id'];
        } catch(error) {
            alert(error);
        }
    }

    // get select option of gender
    const get_gender_option = async () => {
        try {
            const gender_option_response = await axios.post("../backend/retrieve_gender_api.php", {data: "option"});
            // it should be an object (array), keys are index
            gender_option['value'] = gender_option_response.data;
        } catch (error){
            alert(error);
        }
    }

    // get select option of honorifics
    const get_honorifics_option = async () => {
        try {
            const honorifics_option_response = await axios.post("../backend/retrieve_honorifics_api.php", {data: "option"});
            // it should be an object (array), keys are index
            honorifics_option['value'] = honorifics_option_response.data;
        } catch (error){
            alert(error);
        }
    }

    // get select option of country
    const get_country_option = async (search_value) => {
        try {
            if (search_value == null || typeof((search_value).trim()) == "undefined" || (search_value).trim() == ""){
                const country_option_response = await axios.post("../backend/retrieve_country_api.php", {data: "option"});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [country_code, country_name]
                country_option['value'] = country_option_response.data;
            } else {
                const country_option_response = await axios.post("../backend/retrieve_country_api.php", {data: "option", filter: search_value});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [country_code, country_name]
                country_option['value'] = country_option_response.data;
            }
        } catch (error){
            alert(error);
        }
    }

    // get user able to be assigned to
    const get_assign_user_option = async (search_value) => {
        try {
            if (search_value == null || typeof((search_value).trim()) == "undefined" || (search_value).trim() == ""){
                const get_assign_user_option_response = await axios.post("../backend/retrieve_user_api.php");
                assign_to_user_option['value'] = get_assign_user_option_response.data;
            } else {
                var search_array = [];
                search_array.push("user_id:" + search_value.trim());
                search_array.push("user_name:" + search_value.trim());

                const get_assign_user_option_response = await axios.post(
                    "../backend/retrieve_user_api.php", 
                    {
                        requirement: JSON.stringify(search_array)
                    }
                );
                assign_to_user_option['value'] = get_assign_user_option_response.data;
            }
        } catch(error) {
            alert(error);
        }
    }

    // get select option of honorifics
    const get_company_option = async (search_value) => {
        try {
            if (search_value == null || typeof((search_value).trim()) == "undefined" || (search_value).trim() == ""){
                const company_option_response = await axios.post("../backend/retrieve_company_api.php", {data: "option"});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [company_id, company_name, company_address, company_description]
                company_option['value'] = company_option_response.data;
            } else {
                const company_option_response = await axios.post("../backend/retrieve_company_api.php", {data: "option", filter: search_value});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [company_id, company_name, company_address, company_description]
                company_option['value'] = company_option_response.data;
            }
        } catch (error){
            alert(error);
        }
    }

    // get relationship option
    const get_relationship_option = async () => {
        try {
            const relationship_option_response = await axios.post("../backend/retrieve_individual_relationship_api.php", {data: "option"});
            // it should be an object (array), keys are index
            relationship_option['value'] = relationship_option_response.data;
        } catch (error){
            alert(error);
        }
    }

    // get select option of role
    const get_user_role_option = async (search_value) => {
        try {
            if (search_value == null || typeof((search_value).trim()) == "undefined" || (search_value).trim() == ""){
                const role_option_response = await axios.post("../backend/retrieve_user_role_api.php", {data: "option"});
                
                role_option['value'] = role_option_response.data;
            } else {
                const role_option_response = await axios.post("../backend/retrieve_user_role_api.php", {data: "option", filter: search_value});
                
                role_option['value'] = role_option_response.data;
            }
        } catch (error){
            alert(error);
        }
    }

    // detect changes
    const select_changed = (attribute) => {
        if (attribute != null){
            attribute['changed']['value'] = true;
            if (attribute['correspond'] == "lead_status"){

            }
        }
    }

    // input validation & update
    const validate_update_data = async (attribute) => {
        if (attribute['trait'] == "text"){ // for text related
            if (attribute['value']['value'] == response['value']['data'][0][attribute['correspond']]){
                attribute['changed']['value'] = false;
                attribute['has_error']['value'] = false;
            } else {
                const reg_exp = new RegExp(attribute['pattern']);
                if (typeof((attribute['value']['value']).trim()) == "undefined" || (attribute['value']['value']).trim() == ""){
                    if ((attribute['correspond'] == "last_name" && (response['value']['data'][0]['first_name'] == null || response['value']['data'][0]['first_name'] == ""))){
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_visible']['value'] = true;
                        attribute['tooltip_message']['value'] = "Last name and first name cannot be empty at the same time.\nPlease try again.";
                    } else if (attribute['correspond'] == "first_name" && (response['value']['data'][0]['last_name'] == null || response['value']['data'][0]['last_name'] == "")) {
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_visible']['value'] = true;
                        attribute['tooltip_message']['value'] = "Last name and first name cannot be empty at the same time.\nPlease try again.";
                    } else if ((attribute['correspond'] == "phone_number" && response['value']['data'][0]['email_address'] == null) || (attribute['correspond'] == "email_address" && response['value']['data'][0]['phone_number'] == null)){
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_visible']['value'] = true;
                        attribute['tooltip_message']['value'] = "Phone number and email address cannot be empty at the same time.\nPlease try again.";
                    } else { // allow empty value
                        attribute['has_error']['value'] = false;
                        const edit_response = await axios.post(
                            "../backend/edit_lead_api.php",
                            {
                                individual_id: props.individual_id,
                                update_table: (attribute['table']).slice(0, -1),
                                update_attribute: (attribute['correspond']),
                                update_value: null
                            }
                        );
                        if (edit_response.status == 204){
                            success_operation_prompt['value'] = true;
                            get_lead_detail(attribute);
                            attribute['changed']['value'] = false;
                        }
                    }
                } else if (reg_exp.test(attribute['value']['value'])){
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
                        success_operation_prompt['value'] = true;
                        get_lead_detail(attribute);
                        attribute['changed']['value'] = false;
                    } else {
                        // covered duplicate value
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_visible']['value'] = true;
                        attribute['tooltip_message']['value'] = edit_response.data.message;
                    }
                } else {
                    attribute['has_error']['value'] = true;
                    attribute['tooltip_visible']['value'] = true;
                    
                    if (attribute['pattern'] == input_attributes.name_pattern){
                        attribute['tooltip_message']['value'] = input_attributes.name_format_wrong;
                    } else if (attribute['pattern'] == input_attributes.email_pattern){
                        attribute['tooltip_message']['value'] = "The entered email address format is invalid.\nPlease try again. (Format: 'local-part@domain')";
                    } else if (attribute['pattern'] == input_attributes.phone_pattern){
                        attribute['tooltip_message']['value'] = "The entered phone number format is invalid.\nPlease try again. (Format: number between range (8, 20) without special character)";
                    }
                }
            }
        } else if (attribute['trait'] == "select"){ // select type input
            if (attribute['correspond'] == "lead_status"){ // lead status
                if (attribute['value']['value'] == response['value']['data'][0][attribute['correspond']]){ // check if reselect the same value
                    attribute['changed']['value'] = false;
                    attribute['has_error']['value'] = false;
                }
            } else if (attribute['correspond'] == 'company_id' || attribute['correspond'] == 'country_code'){ // for company
                if (attribute['value']['value'] == response['value']['data'][0][attribute['correspond']]){
                    attribute['changed']['value'] = false;
                } else {
                    const edit_response = await axios.post(
                        "../backend/edit_lead_api.php",
                        {
                            individual_id: props.individual_id,
                            update_table: (attribute['table']).slice(0, -1),
                            update_attribute: attribute['correspond'],
                            update_value: attribute['value']['value']
                        }
                    );
                    if (edit_response.status == 204){
                        success_operation_prompt['value'] = true;
                        get_lead_detail(attribute);
                        attribute['changed']['value'] = false;
                    } else {
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_message']['value'] = edit_response.data.message;
                    }
                }
            } else {
                if (attribute['value']['value'] == response['value']['data'][0][attribute['correspond']]){ // gender & honorifics
                    attribute['changed']['value'] = false;
                } else {
                    const edit_response = await axios.post(
                        "../backend/edit_lead_api.php",
                        {
                            individual_id: props.individual_id,
                            update_table: (attribute['table']).slice(0, -1),
                            update_attribute: attribute['correspond'],
                            update_value: "'" + attribute['value']['value'] + "'"
                        }
                    );
                    if (edit_response.status == 204){
                        success_operation_prompt['value'] = true;
                        get_lead_detail(attribute);
                        attribute['changed']['value'] = false;
                    } else {
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_message']['value'] = edit_response.data.message;
                    }
                }
            }
        }
    }

    // validate the creation of an individual
    const can_add = ref(true);
    const validate_create = async () => {
        can_add['value'] = true;

        edit_attribute_left['company_name']['has_error']['value'] = false;
        edit_attribute_left['company_address']['has_error']['value'] = false;

        if (edit_attribute_left['company_name']['value']['value'].trim() == ""){
            edit_attribute_left['company_name']['has_error']['value'] = true;
            edit_attribute_left['company_name']['tooltip_visible']['value'] = true;
            edit_attribute_left['company_name']['tooltip_message']['value'] = "This field cannot be empty";
            can_add['value'] = false;
        }

        if (edit_attribute_left['company_address']['value']['value'].trim() == ""){
            edit_attribute_left['company_address']['has_error']['value'] = true;
            edit_attribute_left['company_address']['tooltip_visible']['value'] = true;
            edit_attribute_left['company_address']['tooltip_message']['value'] = "This field cannot be empty";
            can_add['value'] = false;
        }
    }

    // add the individual into the database
    const create_new_company = async () => {
        await validate_create();

        if (can_add.value){
            try {
                const check_duplicate_response = await axios.post(
                    "../backend/check_company_duplicate_api.php",
                    {
                        company_name: "'" + edit_attribute_left['company_name']['value']['value'].trim() + "'",
                        company_address: "'" + edit_attribute_left['company_address']['value']['value'].trim() + "'"
                    }
                );

                if (check_duplicate_response.status == 204){
                    const create_company_response = await axios.post(
                        "../backend/create_new_company_api.php",
                        {
                            type: "create",
                            company_name: "'" + edit_attribute_left['company_name']['value']['value'].trim() + "'",
                            company_address: "'" + edit_attribute_left['company_address']['value']['value'].trim() + "'",
                            company_description: "'" + edit_attribute_left['company_description']['value']['value'].trim() + "'",
                        }
                    );

                    if (create_company_response.status == 204){
                        create_success_prompt['value'] = true;
                    } else {
                        alert("An unknown error occur, please try again later");
                    }
                } else {
                    edit_attribute_left['company_name']['has_error']['value'] = true;
                    edit_attribute_left['company_name']['tooltip_visible']['value'] = true;
                    edit_attribute_left['company_name']['tooltip_message']['value'] = "Unable to create the following company: there already exists a company with same name and address";
                    edit_attribute_left['company_address']['has_error']['value'] = true;
                    edit_attribute_left['company_address']['tooltip_visible']['value'] = true;
                    edit_attribute_left['company_address']['tooltip_message']['value'] = "Unable to create the following company: there already exists a company with same name and address";
                }
            } catch (error){
                alert(error);
            }
        }
    }

    // initialize / update to get data
    const initialize = async () => {
        get_current_crm_user();
        get_gender_option();
        get_honorifics_option();
        get_assign_user_option();
        get_company_option();
        get_country_option();
        get_relationship_option();
        get_user_role_option();
    }

    initialize();
</script>

<template>
    <div class="flex flex-col w-max h-max">
        <!-- sticky top bar -->
        <div class="flex flex-row items-center justify-between min-w-screen max-w-full h-14 z-5 bg-fuchsia-400 border-b-3 border-pink-700 sticky top-0 shadow-xl">
            <router-link :to="{name: 'lead_page'}" tag="button"><div class="w-10 h-10 bg-[url(/src/assets/icon/back-svgrepo-com.svg)] bg-size-[100%] mx-4 rounded-full hover:bg-rose-50"></div></router-link>
            <div class="text-2xl font-semibold bg-rose-100 px-6 py-1 rounded-full text-pink-800">Company creation page</div>
            <button @click="create_prompt = true; create_new_company();" class="text-white font-semibold bg-green-600 hover:bg-green-800 hover:text-fuchsia-50 mx-4 text-xl px-6 py-1 rounded-full">Create</button>
        </div>

        <div v-if="create_success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">Successfully created company {{ edit_attribute_left['company_name']['value']['value'] }}</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <router-link :to="{name: 'user_page'}" tag="button"><button @click="create_success_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button></router-link>
                </div>
            </div>
        </div>

        <div v-if="success_operation_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The individual data has successfully been updated</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="success_operation_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button>
                </div>
            </div>
        </div>

        <div class="flex flex-col w-screen min-h-screen min-w-max overflow-auto items-center bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500">
            <div class="flex flex-col w-max pt-10">
                <!-- edit part -->
                <div v-if="information_content" class="flex w-full justify-center">
                    <div class="flex flex-row min-w-max w-max m-4 bg-rose-100 rounded-md justify-center border-3 border-pink-700 shadow-xl">
                        <!-- data at left side -->
                        <div :class="css_class_attributes.edit_attribute_area">
                            <div :class="value['class']" v-for="value in edit_attribute_left" :key="value">
                                <label v-if="value['correspond'] != 'conversion_message' || (value['correspond'] == 'conversion_message' && value['changed']['value']== true)" :for="value['correspond'] + '_input'" :class="value['name_class']"><div>{{ value['name'] }}</div></label>
                                <!-- the input field -->
                                <div class="relative">
                                    <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]"  v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                                    <textarea @input="value['changed'].value = true" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed']['value']== true))" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" v-model="value['value'].value" :id="value['correspond'] + '_input'"></textarea>
                                    <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']" :id="value['correspond'] + '_input'">{{ value['value'].value }}</div>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" :id="value['correspond'] + '_input'">
                                        <option v-for="option in value['option_list']['value']" :value="option['role_id']">{{ option['role_name'] }}</option>
                                    </select>
                                    <!-- tooltip content-->
                                    <div v-if="value['has_error'].value" :class="[value['tooltip_visible'].value, css_class_attributes.tooltip]">{{ value['tooltip_message'].value }}</div>
                                </div>
                                <!-- for searchable select -->
                                <div class="flex flex-col">
                                    <input @input="value['search_function']['value'](value['search_value']['value'])" v-if="value['input'] == 'variable_select'" type="search" :id="value['correspond'] + '_input'" :class="css_class_attributes.search_input" :placeholder="value['search_placeholder']['value']" v-model="value['search_value']['value']"/>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-if="value['input'] == 'variable_select'" v-model="value['value']['value']" :class="value['input_class']">
                                        <option :class="css_class_attributes.option_input" v-for="option in value['option_list']['value']" :value="option[value['correspond']]"> {{ option[value['value_name']['value']] }} </option>
                                        <option :class="css_class_attributes.option_input" :value="null">NULL</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>
</template>

<style>

</style>