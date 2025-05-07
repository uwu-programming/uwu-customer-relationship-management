<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        company_id: String // for accessing specific individual
    });

    // current crm user
    const current_crm_user = ref("");
    const current_crm_user_role = ref("");

    // store the response from API request
    const response = ref("");
    const activity_type_option = ref("");
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
    const individual_add_list = ref([]);
    const individual_drop_list = ref([]);

    // search v-model
    const add_search_value = ref("");
    const drop_search_value = ref("");

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);
    const conversion_history_exist = ref(false);

    // check if delete is activated
    const create_prompt = ref(false);
    const create_success_prompt = ref(false);
    const success_operation_prompt = ref(false);
    const delete_prompt = ref(false);
    const delete_success_prompt = ref(false);

    // check which content to load
    const information_content = ref(true);
    const conversion_history_content = ref(false);

    // store each type of individual under this company
    const contact_individual = ref("");
    const lead_individual = ref("");
    const customer_individual = ref("");

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
        time_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-md cursor-pointer px-2 overflow-auto text-nowrap truncate shadow-xl",
        paragraph_input: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-40 mx-3 px-2 py-1 overflow-auto border-2 focus:bg-gray-100 border-pink-700 rounded-md bg-white shadow-xl",
        paragraph_input_short: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-20 mx-3 px-2 py-1 overflow-y-scroll focus:bg-gray-100 border-2 border-pink-700 rounded-sm bg-white",
        variable_select_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-sm cursor-pointer px-2 pr-5 hover:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        option_input: "",
        search_input: "focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-8 w-100 mx-3 mb-2 bg-white rounded-full border-2 border-pink-700 cursor-pointer focus:cursor-text px-2 hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        small_search_input: "focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-8 w-80 mx-3 mb-2 bg-white rounded-full border-2 border-pink-700 cursor-pointer focus:cursor-text px-2 hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",

        none: "h-8 w-100 mx-3 bg-white rounded-md border-pink-700 border-2 focus:bg-gray-100 focus:cursor-text focus:shadow-pink-500/50 shadow-xl px-2 invalid:shadow-red-600 overflow-auto text-nowrap truncate",

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
        datetime: "datetime-local",


        name_pattern: "[A-Z]{1}([a-zA-Z ]*)([a-zA-Z]+)$",
        phone_pattern: "[0-9]{8,20}$",
        email_pattern: "([a-z,0-9]{2,})@([a-z,0-9]{2,}).([a-z]{2,})$",

        trait_text: "text",
        trait_select: "select",
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

    // get current role
    const get_current_crm_user_role = async () => {
        try {
            const get_current_crm_user_role_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user_role['value'] = get_current_crm_user_role_response['data']['user_id'];
        } catch(error) {
            alert(error);
        }
    }

    // get activity option
    const get_activity_option = async () => {
        try {
            const activity_option_response = await axios.post("../backend/retrieve_activity_option_api.php", {data: "option"});
            // it should be an object (array), keys are index
            activity_type_option['value'] = activity_option_response.data;
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

    // get company information
    const retrieve_company = async () => {
        try {
            response['value'] = await axios.post(
                "../backend/retrieve_company_api.php",
                {
                    company_id: props.company_id
                }
            );
        } catch (error) {
            alert(error);
        }

        success_response['value'] = (response['value'].data[0] != undefined);

        if (success_response['value']){
            edit_attribute_left['company_name']['value']['value'] = response['value'].data[0]['company_name'];
            edit_attribute_left['company_address']['value']['value'] = response['value'].data[0]['company_address'];
            edit_attribute_left['company_description']['value']['value'] = response['value'].data[0]['company_description'];
        }
    }

    // retrieve all individual under this company
    const retrieve_company_individual = async () => {
        try {
            const company_contact_response = await axios.post(
                "../backend/retrieve_company_individual_api.php",
                {
                    company_id: props.company_id,
                    relationship: "Contact"
                }
            );

            contact_individual['value'] = company_contact_response.data;
        } catch (error){
            alert(error);
        }

        try {
            const company_lead_response = await axios.post(
                "../backend/retrieve_company_individual_api.php",
                {
                    company_id: props.company_id,
                    relationship: "Lead"
                }
            );

            lead_individual['value'] = company_lead_response.data;
        } catch (error){
            alert(error);
        }

        try {
            const company_customer_response = await axios.post(
                "../backend/retrieve_company_individual_api.php",
                {
                    company_id: props.company_id,
                    relationship: "Customer"
                }
            );

            customer_individual['value'] = company_customer_response.data;
        } catch (error){
            alert(error);
        }
    }

    // delete company
    const delete_company = async () => {
        try {
            
        } catch (error) {
            alert(error);
        }
    }

    // validate changes and save
    const validate_update_data = async (value) => {
        if (value['value']['value'] == response['value']['data'][0][value['correspond']]){
            value['changed']['value'] = false;
        } else {
            if (value['correspond'] == "company_name" || value['correspond'] == "company_address"){
                if (value['value']['value'].trim() == ""){
                    value['has_error']['value'] = true;
                    value['tooltip_visible']['value'] = true;
                    value['tooltip_message']['value'] = "This field cannot be empty";
                } else {
                    if (value['correspond'] == "company_name"){
                        const check_duplicate_response = await axios.post(
                            "../backend/check_company_duplicate_api.php",
                            {
                                company_name: edit_attribute_left['company_name']['value']['value'],
                                company_address: response['value']['data'][0][value['correspond']]
                            }
                        );

                        if (check_duplicate_response.status == 204){
                            try{
                                const update_response = await axios.post(
                                    "../backend/update_company_api.php",
                                    {
                                        attribute: value['correspond'],
                                        value: value['value']['value'].trim(),
                                        company_id: props.company_id
                                    }
                                );
                                if (update_response.status == 204){
                                    value['changed']['value'] = false;
                                    success_operation_prompt['value'] = true;
                                }
                            } catch (error){
                                alert(error);
                            }
                        } else {
                            edit_attribute_left['company_name']['has_error']['value'] = true;
                            edit_attribute_left['company_name']['tooltip_visible']['value'] = true;
                            edit_attribute_left['company_name']['tooltip_message']['value'] = "Unable to update company name: there already exists a company with same name and address";
                        }
                    } else if (value['correspond'] == "company_address"){
                        const check_duplicate_response = await axios.post(
                            "../backend/check_company_duplicate_api.php",
                            {
                                company_name: response['value']['data'][0][value['correspond']],
                                company_address: edit_attribute_left['company_name']['value']['value']
                            }
                        );

                        if (check_duplicate_response.status == 204){
                            try {
                                const update_response = await axios.post(
                                    "../backend/update_company_api.php",
                                    {
                                        attribute: value['correspond'],
                                        value: value['value']['value'].trim(),
                                        company_id: props.company_id
                                    }
                                );
                                if (update_response.status == 204){
                                    value['changed']['value'] = false;
                                    success_operation_prompt['value'] = true;
                                }
                            } catch (error){
                                alert(error);
                            }
                        } else {
                            edit_attribute_left['company_address']['has_error']['value'] = true;
                            edit_attribute_left['company_address']['tooltip_visible']['value'] = true;
                            edit_attribute_left['company_address']['tooltip_message']['value'] = "Unable to update company address: there already exists a company with same name and address";
                        }
                    }
                }
            } else {
                try {
                    const update_response = await axios.post(
                        "../backend/update_company_api.php",
                        {
                            attribute: value['correspond'],
                            value: value['value']['value'].trim(),
                            company_id: props.company_id
                        }
                    );
                    if (update_response.status == 204){
                        value['changed']['value'] = false;
                        success_operation_prompt['value'] = true;
                    }
                } catch (error){
                    alert(error);
                }
            }
        }
    }

    // cancel changes
    const cancel_changes = (value) => {
        value['changed']['value'] = false;
        value['has_error']['value'] = false;
        value['value']['value'] = response['value'].data[0][value['correspond']];
    }

    // check login
    const is_login = ref(false);
    const check_is_login = async () => {
        const check_is_login_response = await axios.post(
            "../backend/check_login_api.php",
        );

        if (check_is_login_response.status == 204){
            is_login['value'] = true;
        } else {
            is_login['value'] = false;
        }
    }

    // initialize / update to get data
    const initialize = async () => {
        get_current_crm_user();
        get_current_crm_user_role();
        retrieve_company();
        retrieve_company_individual();
        check_is_login();
    }

    initialize();
</script>

<template>
    <div class="flex flex-col w-max h-max" v-if="is_login">
        <!-- sticky top bar -->
        <div class="flex flex-row items-center justify-between min-w-screen max-w-full h-14 z-5 bg-fuchsia-400 border-b-3 border-pink-700 sticky top-0 shadow-xl">
            <router-link :to="{name: 'company_page'}" tag="button"><div class="w-10 h-10 bg-[url(/src/assets/icon/back-svgrepo-com.svg)] bg-size-[100%] mx-4 rounded-full hover:bg-rose-50"></div></router-link>
            <div class="text-2xl font-semibold bg-rose-100 px-6 py-1 rounded-full text-pink-800">Company editing page</div>
            <button v-if="success_response" @click="delete_prompt = true" class="text-white font-semibold bg-red-600 hover:bg-red-800 hover:text-fuchsia-50 mx-4 text-xl px-6 py-1 rounded-full">Delete</button>
            <div v-else class="w-25 mx-4"></div>
        </div>

        <div v-if="create_success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The activity has successfully been created</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <router-link :to="{name: 'activity_page'}" tag="button"><button @click="create_success_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button></router-link>
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

        <div v-if="delete_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">Are you sure you want to remove this company?</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="delete_prompt = false; delete_company();" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Yes</button>
                    <button @click="delete_prompt = false" class="w-28 mx-4 px-6 py-1 bg-red-600 rounded-full hover:text-fuchsia-50 hover:bg-red-800">No</button>
                </div>
            </div>
        </div>

        <div v-if="delete_success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The company has successfully been removed</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="delete_success_prompt = false; retrieve_company();" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button>
                </div>
            </div>
        </div>

        <div v-if="success_response" class="flex flex-col w-screen min-h-screen min-w-max overflow-auto items-center bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500">
            <div class="flex flex-col w-max pt-10 items-center">
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
                                        <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
                                    </select>
                                    <input @input="value['changed'].value = true" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-model="value['value']['value']" v-else-if="value['input'] == 'datetime-local'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" type="datetime-local"/>
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
                                <!-- save changes -->
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

                <!-- display all individual under this company -->
                <div class="flex flex-col h-210 w-full m-4 overflow-auto bg-pink-300 border-pink-700 border-3 rounded-md">
                    <div class="px-4 py-1 font-bold text-lg decoration-2 decoration-pink-700 underline">Individual under this company</div>
                    
                    <div class="flex flex-col border-pink-700 border-3 rounded-md m-2 h-1/3 bg-rose-100">
                        <div class="font-bold bg-pink-500 border-b-3 border-pink-700"><div class="flex w-max px-6 text-lg rounded-sm my-2 mx-4 bg-pink-300 border-pink-700 border-3">Contact</div></div>
                        <div class="flex flex-col overflow-auto">
                            <div v-for="value in contact_individual">
                                <router-link v-if="current_crm_user_role <= 2" class="flex px-4 py-2 my-1 mx-2 border-pink-700/70 border-b-2 hover:bg-pink-300" :to="{name: 'contact_edit_page', params: {individual_id: value['individual_id']}}" tag="button">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['first_name'] }} {{ value['last_name'] }}</router-link>
                                <router-link v-else class="flex px-4 py-2 my-1 mx-2 border-pink-700/70 border-b-2 hover:bg-pink-300" :to="{name: 'contact_view_page', params: {individual_id: value['individual_id']}}" tag="button">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['first_name'] }} {{ value['last_name'] }}</router-link>
                            </div>
                        </div>
                    </div>

                    <div class="flex flex-col border-pink-700 border-3 rounded-md m-2 h-1/3 bg-rose-100">
                        <div class="font-bold bg-pink-500 border-b-3 border-pink-700"><div class="flex w-max px-6 text-lg rounded-sm my-2 mx-4 bg-pink-300 border-pink-700 border-3">Lead</div></div>
                        <div class="flex flex-col overflow-auto">
                            <div v-for="value in lead_individual">
                                <router-link class="flex px-4 py-2 my-1 mx-2 border-pink-700/70 border-b-2 hover:bg-pink-300" :to="{name: 'lead_edit_page', params: {individual_id: value['individual_id']}}" tag="button">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['first_name'] }} {{ value['last_name'] }}</router-link>
                            </div>
                        </div>
                    </div>

                    <div class="flex flex-col border-pink-700 border-3 rounded-md m-2 h-1/3 bg-rose-100">
                        <div class="font-bold bg-pink-500 border-b-3 border-pink-700"><div class="flex w-max px-6 text-lg rounded-sm my-2 mx-4 bg-pink-300 border-pink-700 border-3">Customer</div></div>
                        <div class="flex flex-col overflow-auto">
                            <div v-for="value in customer_individual">
                                <router-link v-if="current_crm_user_role <= 2" class="flex px-4 py-2 my-1 mx-2 border-pink-700/70 border-b-2 hover:bg-pink-300" :to="{name: 'customer_edit_page', params: {individual_id: value['individual_id']}}" tag="button">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['first_name'] }} {{ value['last_name'] }}</router-link>
                                <router-link v-else class="flex px-4 py-2 my-1 mx-2 border-pink-700/70 border-b-2 hover:bg-pink-300" :to="{name: 'customer_view_page', params: {individual_id: value['individual_id']}}" tag="button">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['first_name'] }} {{ value['last_name'] }}</router-link>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div v-else class="flex justify-center items-center w-screen h-screen bg-rose-400">
            This company is no longer exist
        </div>

    </div>

    <div v-else class="w-screen h-screen flex flex-col bg-pink-300 justify-center items-center">
        <div>Unable to acceess the page due to unauthorized access, please log in to continue</div>
        <router-link class="bg-rose-500 hover:bg-rose-800 font-semibold hover:text-white rounded-full px-6 py-1 m-2" :to="{name: 'login_page'}" tag="button">Login at here</router-link>
    </div>
</template>

<style>

</style>