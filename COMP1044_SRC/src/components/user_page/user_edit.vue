<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        user_id: String // for accessing specific individual
    });

    // store the response from API request
    const response = ref("");
    const user = ref("");
    const gender_option = ref("");
    const honorifics_option = ref("");
    const country_option = ref("");
    const lead_status_option = ref("");
    const company_option = ref("");
    const chosen_company_id = ref("");
    const conversion_history_response = ref("");

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);
    const conversion_history_exist = ref(false);

    // check if delete is activated
    const delete_prompt = ref(false);
    const delete_success_prompt = ref(false);
    const success_operation_prompt = ref(false);

    // check which content to load
    const information_content = ref(true);
    const conversion_history_content = ref(false);

    // referenceable CSS attribute
    const css_class_attributes = {
        edit_attribute_area: "flex flex-col w-max h-max mx-5 px-5 py-2 my-2",

        normal_edit_attribute: "flex flex-row mb-4 items-center",
        description_edit_attribute: "flex flex-row mb-4",
        search_select_edit_attribute: "flex flex-row mb-4",
        normal_label: "w-48 flex justify-end px-2 py-1 mx-1 border-b-2 border-pink-700 font-bold",
        text_input: "h-8 w-100 mx-3 bg-white rounded-md border-pink-700 border-2 cursor-pointer focus:bg-gray-100 focus:cursor-text focus:shadow-pink-500/50 shadow-xl px-2 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        text_show: "h-8 w-100 mx-3 bg-white rounded-md border-pink-700 border-2 shadow-xl px-2 overflow-auto text-nowrap truncate",
        text_area_input: "focus:shadow-pink-500/50 shadow-xl w-100 h-40 mx-3 border-2 border-pink-700 focus:bg-gray-100 rounded-sm bg-white cursor-pointer focus:cursor-text px-2 py-1 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-top-right bg-size-[5%_auto] bg-origin-content resize-none",
        text_area_input_short: "focus:shadow-pink-500/50 shadow-xl w-100 h-25 mx-3 border-2 border-pink-700 focus:bg-gray-100 rounded-sm bg-white cursor-pointer focus:cursor-text px-2 py-1 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-top-right bg-size-[5%_auto] bg-origin-content resize-none",
        select_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-md cursor-pointer px-2 pr-5 hover:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        paragraph_input: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-40 mx-3 px-2 py-1 overflow-auto border-2 focus:bg-gray-100 border-pink-700 rounded-md bg-white",
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
        span: "span",
        paragraph: "paragraph",
        fixed_select: "fixed_select",
        variable_select: "variable_select",


        name_pattern: "([a-zA-Z])([a-zA-Z ]*)([a-zA-Z]+)$",

        trait_text: "text",
        trait_select: "select",

        name_format_wrong: "Bad user name format, please try again. \n(User name can only contain alphabet and space)",
    }

    // ref to store the display attribute
    const edit_attribute_left = {
        user_id: {
            name: "User ID",
            correspond: "user_id",
            table: "crm_user.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.text_show,
            input: input_attributes.paragraph,
            trait: input_attributes.trait_text,
            pattern: input_attributes.name_pattern,
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        user_name: {
            name: "User name",
            correspond: "user_name",
            table: "crm_user.",
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
        role: {
            name: "Role",
            correspond: "role_id",
            table: "crm_user.",
            class: css_class_attributes.search_select_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.variable_select_input,
            input: input_attributes.variable_select,
            trait: input_attributes.trait_select,
            value: ref(""),
            value_name: ref("role_name"),
            search_value: ref(""),
            search_placeholder: ref("Search for a role name..."),
            search_function: ref("get"),
            option_list: ref(country_option),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
    }

    // retrieve the lead to edit
    const get_user_detail = async (attribute) => {
        try {
            response.value = await axios.post("../backend/retrieve_user_api.php", {requirement: JSON.stringify(["user_id:" + props.user_id]), hard_requirement: true});
            // check if the retrieve is success (by checking if the object has key)
            success_response.value = (Object.keys(response.value.data)).length > 0;

            if (success_response.value && attribute == null){
                for (const key in edit_attribute_left)
                    edit_attribute_left[key]['value'].value = response.value.data[0][edit_attribute_left[key]['correspond']];
            } else if (success_response.value){
                attribute['value']['value'] = response.value.data[0][attribute['correspond']];
            }
        } catch (error){
            alert(error);
        }
    }

    // get select option of country
    const get_user_role_option = async (search_value) => {
        try {
            if (search_value == null || typeof((search_value).trim()) == "undefined" || (search_value).trim() == ""){
                const country_option_response = await axios.post("../backend/retrieve_user_role_api.php", {data: "option"});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [country_code, country_name]
                country_option['value'] = country_option_response.data;
            } else {
                const country_option_response = await axios.post("../backend/retrieve_user_role_api.php", {data: "option", filter: search_value});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [country_code, country_name]
                country_option['value'] = country_option_response.data;
            }
        } catch (error){
            alert(error);
        }
    }
    edit_attribute_left['role']['search_function']['value'] = get_user_role_option;

    // get select option of honorifics
    const get_company_option = async (search_value) => {
        try {
            if (search_value == null || typeof((search_value).trim()) == "undefined" || (search_value).trim() == ""){
                const company_option_response = await axios.post("../backend/retrieve_user_role_api.php", {data: "option"});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [company_id, company_name, company_address, company_description]
                company_option['value'] = company_option_response.data;
            } else {
                const company_option_response = await axios.post("../backend/retrieve_user_role_api.php", {data: "option", filter: search_value});
                
                // should be [object Object]
                // first layer key is index (0,1,...)
                // second layer keys are: [company_id, company_name, company_address, company_description]
                company_option['value'] = company_option_response.data;
            }
        } catch (error){
            alert(error);
        }
    }

    // detect changes
    const select_changed = (attribute) => {
        if (attribute != null){
            attribute['changed']['value'] = true;
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
                            "../backend/edit_user_api.php",
                            {
                                user_id: props.user_id,
                                update_table: (attribute['table']).slice(0, -1),
                                update_attribute: (attribute['correspond']),
                                update_value: null
                            }
                        );
                        if (edit_response.status == 204){
                            success_operation_prompt['value'] = true;
                            get_user_detail(attribute);
                            attribute['changed']['value'] = false;
                        }
                    }
                } else if (reg_exp.test(attribute['value']['value'])){
                    attribute['has_error']['value'] = false;
                    const edit_response = await axios.post(
                        "../backend/edit_user_api.php",
                        {
                            user_id: props.user_id,
                            update_table: (attribute['table']).slice(0, -1),
                            update_attribute: (attribute['correspond']),
                            update_value: "'" + attribute['value']['value'] + "'"
                        }
                    );
                    if (edit_response.status == 204){
                        success_operation_prompt['value'] = true;
                        get_user_detail(attribute);
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
            } else if (attribute['correspond'] == 'company_id' || attribute['correspond'] == 'role_id'){ // for company
                if (attribute['value']['value'] == response['value']['data'][0][attribute['correspond']]){
                    attribute['changed']['value'] = false;
                } else {
                    const edit_response = await axios.post(
                        "../backend/edit_user_api.php",
                        {
                            user_id: props.user_id,
                            update_table: (attribute['table']).slice(0, -1),
                            update_attribute: attribute['correspond'],
                            update_value: attribute['value']['value']
                        }
                    );
                    if (edit_response.status == 204){
                        success_operation_prompt['value'] = true;
                        get_user_detail(attribute);
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
                        "../backend/edit_user_api.php",
                        {
                            user_id: props.user_id,
                            update_table: (attribute['table']).slice(0, -1),
                            update_attribute: attribute['correspond'],
                            update_value: "'" + attribute['value']['value'] + "'"
                        }
                    );
                    if (edit_response.status == 204){
                        success_operation_prompt['value'] = true;
                        get_user_detail(attribute);
                        attribute['changed']['value'] = false;
                    } else {
                        attribute['has_error']['value'] = true;
                        attribute['tooltip_message']['value'] = edit_response.data.message;
                    }
                }
            }
        }
    }

    // cancel changes
    const cancel_changes = (attribute) => {
        attribute['changed']['value'] = false;
        attribute['has_error']['value'] = false;
        attribute['value']['value'] = response.value.data[0][attribute['correspond']];
    }

    // delete lead
    const delete_lead = async () => {
        delete_prompt['value'] = false;

        const delete_response = await axios.post(
            "../backend/edit_user_api.php",
            {
                user_id: props.user_id,
                update_table: null,
                update_attribute: null,
                update_value: null,
                operation: "DELETE"
            }
        );

        if (delete_response.status == 204){
            delete_success_prompt['value'] = true;
            initialize();
        } else {
            alert(delete_response.data.message);
        }
    }

    // initialize / update to get data
    const initialize = async () => {
        get_user_detail();
        get_user_role_option();
    }

    initialize();
</script>

<template>
    <div class="flex flex-col w-max h-max">
        <!-- sticky top bar -->
        <div class="flex flex-row items-center justify-between min-w-screen max-w-full h-14 z-5 bg-fuchsia-400 border-b-3 border-pink-700 sticky top-0 shadow-xl">
            <router-link :to="{name: 'user_page'}" tag="button"><div class="w-10 h-10 bg-[url(/src/assets/icon/back-svgrepo-com.svg)] bg-size-[100%] mx-4 rounded-full hover:bg-rose-50"></div></router-link>
            <div class="text-2xl font-semibold bg-rose-100 px-6 py-1 rounded-full text-pink-800">User editing page</div>
            <button @click="delete_prompt = true" v-if="success_response" class="text-white font-semibold bg-rose-600 hover:bg-rose-800 hover:text-fuchsia-50 mx-4 text-xl px-6 py-1 rounded-full">Delete</button>
            <div v-else class="w-34"></div>
        </div>

        <div v-if="delete_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">Are you sure you want to remove this user?</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="delete_lead()" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Yes</button>
                    <button @click="delete_prompt = false" class="w-28 mx-4 px-6 py-1 bg-red-600 rounded-full hover:text-fuchsia-50 hover:bg-red-800">No</button>
                </div>
            </div>
        </div>

        <div v-if="delete_success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The user has successfully been removed</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="delete_success_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button>
                </div>
            </div>
        </div>

        <div v-if="success_operation_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The user data has successfully been updated</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="success_operation_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button>
                </div>
            </div>
        </div>

        <div v-if="success_response" class="flex flex-col w-screen min-h-screen min-w-max overflow-auto items-center bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500 pt-10">
            <div class="flex flex-col w-max">

                <!-- edit part -->
                <div v-if="information_content" class="flex w-full justify-center">
                    <div class="flex flex-row min-w-max w-max m-4 bg-rose-100 rounded-md justify-center border-3 border-pink-700 shadow-xl">
                        <!-- data at left side -->
                        <div :class="css_class_attributes.edit_attribute_area">
                            <div :class="value['class']" v-for="value in edit_attribute_left" :key="value">
                                <label v-if="value['correspond'] != 'conversion_message' || (value['correspond'] == 'conversion_message' && value['changed']['value']== true)" :for="value['correspond'] + '_input'" :class="value['name_class']"><div>{{ value['name'] }}</div></label>
                                <!-- the input field -->
                                <div class="relative">
                                    <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" :pattern="value['pattern']" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]"  v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                                    <textarea @input="value['changed'].value = true" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed']['value']== true))" :class="value['input_class']" v-model="value['value'].value" :id="value['correspond'] + '_input'"></textarea>
                                    <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']" :id="value['correspond'] + '_input'">{{ value['value'].value }}</div>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']" :class="value['input_class']" :id="value['correspond'] + '_input'">
                                        <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
                                    </select>
                                    <span v-else-if="value['input'] == 'span'" :class="value['input_class']" :id="value['correspond'] + '_input'">{{ value['value'].value }}</span>
                                    <!-- tooltip content-->
                                    <div v-if="value['has_error'].value" :class="[value['tooltip_visible'].value, css_class_attributes.tooltip]">{{ value['tooltip_message'].value }}</div>
                                </div>
                                <!-- for searchable select -->
                                <div class="flex flex-col">
                                    <input @input="value['search_function']['value'](value['search_value']['value'])" v-if="value['input'] == 'variable_select'" type="search" :id="value['correspond'] + '_input'" :class="css_class_attributes.search_input" :placeholder="value['search_placeholder']['value']" v-model="value['search_value']['value']"/>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-if="value['input'] == 'variable_select'" v-model="value['value']['value']" :class="value['input_class']">
                                        <option :class="css_class_attributes.option_input" v-for="option in value['option_list']['value']" :value="option[value['correspond']]"> {{ option[value['value_name']['value']] }} </option>
                                    </select>
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

            </div>
        </div>
        
        <div v-else class="flex justify-center items-center w-screen h-screen bg-rose-400">
            You don't have permission to view / edit this user, or this user is no longer exist
        </div>
    </div>
</template>

<style>

</style>