<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        individual_id: String // for accessing specific individual
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

    // store the reference on whether it has sucessfully retrieved data
    const success_response = ref(false);

    // referenceable CSS attribute
    const css_class_attributes = {
        edit_attribute_area: "flex flex-col w-max h-max mx-5 px-5 py-2 my-2",

        normal_edit_attribute: "flex flex-row mb-4 items-center",
        description_edit_attribute: "flex flex-row mb-4",
        search_select_edit_attribute: "flex flex-row mb-4",
        normal_label: "w-48 flex justify-end px-2 py-1 mx-1 border-b-2 border-pink-700 font-bold",
        text_input: "h-8 w-100 mx-3 bg-white rounded-md border-pink-700 border-2 cursor-pointer focus:bg-gray-100 focus:cursor-text focus:shadow-pink-500/50 shadow-xl px-2 hover:bg-[url(/src/assets/icon/pen-solid.svg)] focus:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
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
        tooltip: "flex w-100 h-14 bg-rose-500 border-2 border-rose-800 absolute z-2 m-1 -top-16 left-2 py-1 px-2 text-xs whitespace-pre-line rounded-sm",

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


        name_pattern: "[A-Z]{1}([a-zA-Z ]*)([a-zA-Z]+)$",
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
            value: ref(""),
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
            value: ref(""),
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
            value: ref(""),
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
            input_class: css_class_attributes.select_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(gender_option),
            value: ref(""),
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
            input_class: css_class_attributes.select_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(honorifics_option),
            value: ref(""),
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
            value: ref(""),
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
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        country: {
            name: "Country",
            correspond: "country_code",
            table: "individual.",
            class: css_class_attributes.search_select_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.variable_select_input,
            input: input_attributes.variable_select,
            trait: input_attributes.trait_select,
            value: ref(""),
            value_name: ref("country_name"),
            search_value: ref(""),
            search_placeholder: ref("Search for country name..."),
            search_function: ref(""),
            option_list: ref(country_option),
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
            value: ref(""),
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
            input_class: css_class_attributes.select_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(lead_status_option),
            value: ref(""),
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
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        company: {
            name: "Company",
            correspond: "company_id",
            table: "individual.",
            class: css_class_attributes.search_select_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.variable_select_input,
            input: input_attributes.variable_select,
            trait: input_attributes.trait_select,
            value: ref(""),
            value_name: ref("company_name"),
            search_value: ref(""),
            search_placeholder: ref("Search for company name..."),
            search_function: ref(""),
            option_list: ref(company_option),
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
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.paragraph_input,
            input: input_attributes.paragraph,
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        }
    }

    const overview_attribute = {
        lead_name: {
            name: "Lead name",
            value: ref(""),
            correspond: ""
        },
        lead_owner: {
            name: "Lead owner",
            correspond: "lead_owner_name",
            table: "crm_user.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            value: ref(""),
            hover: ref(false),
        },
        lead_owner_id: {
            name: "Lead owner ID",
            correspond: "lead_owner_user_id",
            table: "lead_individual.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            value: ref(""),
            hover: ref(false),
        },
        lead_status: {
            name: "Lead status",
            correspond: "lead_status",
            table: "lead_individual.",
            class: css_class_attributes.description_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: "",
            value: ref(""),
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
            value: ref(""),
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
            value: ref(""),
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
                for (const key in edit_attribute_right){
                    edit_attribute_right[key]['value'].value = response.value.data[0][edit_attribute_right[key]['correspond']];
                }
                for (const key in overview_attribute)
                    overview_attribute[key]['value'].value = response.value.data[0][overview_attribute[key]['correspond']];
                overview_attribute['lead_name']['value']['value'] = (response.value.data[0]['first_name'] == null ? "" : response.value.data[0]['first_name'] + " ") + (response.value.data[0]['middle_name'] == null ? "" : response.value.data[0]['middle_name'] + " ") + (response.value.data[0]['last_name'] == null ? "" : response.value.data[0]['last_name']);
            } else if (success_response.value){
                attribute['value']['value'] = response.value.data[0][attribute['correspond']];
                for (const key in overview_attribute)
                    overview_attribute[key]['value'].value = response.value.data[0][overview_attribute[key]['correspond']];
                overview_attribute['lead_name']['value']['value'] = (response.value.data[0]['first_name'] == null ? "" : response.value.data[0]['first_name'] + " ") + (response.value.data[0]['middle_name'] == null ? "" : response.value.data[0]['middle_name'] + " ") + (response.value.data[0]['last_name'] == null ? "" : response.value.data[0]['last_name']);
            }
        } catch (error){
            alert(error);
        }
    }

    // get select option of lead status
    const get_lead_status_option = async () => {
        try {
            const lead_status_option_response = await axios.post("../backend/retrieve_lead_status_api.php", {data: "option"});
            // it should be an object (array), keys are index
            lead_status_option['value'] = lead_status_option_response.data;
        } catch (error){
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
    // bind the function to country
    edit_attribute_left['country']['search_function']['value'] = get_country_option;

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
    // bind the function to company
    edit_attribute_right['company']['search_function']['value'] = get_company_option;

    // detect changes
    const select_changed = (attribute) => {
        if (attribute != null){
            attribute['changed']['value'] = true;
            if (attribute['correspond'] == "lead_status"){
                edit_attribute_right['lead_conversion_message']['changed']['value']= true;
            } else if (attribute['correspond'] == "company_id"){
                // display company address and description on changed
                for (const key in company_option['value']){
                    if (company_option['value'][key]['company_id'] == attribute['value']['value']){
                        edit_attribute_right['company_address']['value']['value'] = company_option['value'][key]['company_address'];
                        edit_attribute_right['company_description']['value']['value'] = company_option['value'][key]['company_description'];
                        chosen_company_id['value'] = company_option['value'][key]['company_id'];
                    }
                }

                if (attribute['value']['value'] == null){
                    edit_attribute_right['company_address']['value']['value'] = "";
                    edit_attribute_right['company_description']['value']['value'] = "";
                }
            }
        }
    }

    // input validation & update
    const validate_update_data = async (attribute) => {
        if (attribute['trait'] == "text"){ // for text related
            if (attribute['value']['value'] == response['value']['data'][0][attribute['correspond']]){
                attribute['changed']['value'] = false;
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
                            alert("success");
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
                        alert("success");
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
                    edit_attribute_right['lead_conversion_message']['changed']['value'] = false;
                    edit_attribute_right['lead_conversion_message']['has_error']['value'] = false;
                    edit_attribute_right['lead_conversion_message']['value']['value'];
                } else {
                    if (typeof(edit_attribute_right['lead_conversion_message']['value']['value']) == "undefined" || (edit_attribute_right['lead_conversion_message']['value']['value']).trim() == ""){ // check to prevent empty conversion message
                        edit_attribute_right['lead_conversion_message']['has_error']['value'] = true;
                        attribute['has_error']['value'] = true;
                        edit_attribute_right['lead_conversion_message']['tooltip_message']['value'] = "Lead conversion message can't be empty";
                        attribute['tooltip_message']['value'] = "Lead conversion message can't be empty";
                    } else {
                        const edit_response = await axios.post(
                            "../backend/edit_lead_api.php",
                            {
                                individual_id: props.individual_id,
                                update_table: (attribute['table']).slice(0, -1),
                                update_attribute: attribute['correspond'],
                                update_value: "'" + attribute['value']['value'] + "'",
                                convert_from: "'" + response['value']['data'][0]['lead_status'] + "'",
                                conversion_message: "'" + edit_attribute_right['lead_conversion_message']['value']['value'] + "'"
                            }
                        );
                        if (edit_response.status == 204){
                            alert("success");
                            get_lead_detail(attribute);
                            attribute['changed']['value'] = false;
                            edit_attribute_right['lead_conversion_message']['changed']['value'] = false;
                            edit_attribute_right['lead_conversion_message']['value']['value'] = "";
                        } else {
                            alert(edit_response.data.message);
                        }
                    }
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
                        alert("success");
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
                        alert("success");
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

    // cancel changes
    const cancel_changes = (attribute) => {
        attribute['changed']['value'] = false;
        attribute['has_error']['value'] = false;
        attribute['value']['value'] = response.value.data[0][attribute['correspond']];

        if (attribute['correspond'] == "lead_status"){
            edit_attribute_right['lead_conversion_message']['changed']['value'] = false;
            edit_attribute_right['lead_conversion_message']['has_error']['value'] = false;
            edit_attribute_right['lead_conversion_message']['value']['value'] = "";
        } else if (attribute['correspond'] == 'company_id'){
            edit_attribute_right['company_address']['value']['value'] = response.value.data[0][attribute['company_address']];
            edit_attribute_right['company_description']['value']['value'] = response.value.data[0][attribute['company_description']];
            chosen_company_id['value'] = response.value.data[0][attribute['company_id']];
        }
    }

    // initialize / update to get data
    const initialize = async () => {
        get_lead_detail();
        get_lead_status_option();
        get_gender_option();
        get_honorifics_option();
        get_company_option();
        get_country_option();
    }

    initialize();
</script>

<template>
    <div v-if="success_response" class="flex flex-col w-screen min-h-screen min-w-max overflow-auto justify-center items-center bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500">

        <!-- basic display part -->
        <div class="flex flex-col m-2">
            <div class="flex flex-col min-w-340 max-w-full overflow-auto px-2 py-2 bg-rose-100 rounded-md">
                <div class="flex flex-row w-ful" v-for="value in overview_attribute">
                    <div class="flex w-60 m-1 justify-end items-end font-bold border-pink-700 border-b-1">{{ value['name'] }}</div>
                    <div class="flex w-full m-1 ml-8 px-2 border-pink-700 border-b-1">{{ value['value'].value }}</div>
                </div>
            </div>
        </div>

        <!-- edit part -->
         <div class="flex w-full justify-center">
            <div class="flex flex-row min-w-max w-max m-4 bg-rose-100 rounded-md justify-center">
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
                        <label v-if="value['correspond'] != 'conversion_message' || (value['correspond'] == 'conversion_message' && value['changed']['value']== true)" :for="value['correspond'] + '_input'" :class="value['name_class']"><div>{{ value['name'] }}</div></label>
                        <!-- the input field -->
                        <div class="relative">
                            <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" :pattern="value['pattern']" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]"  v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                            <textarea @input="value['changed'].value = true" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed']['value']== true))" :class="value['input_class']" v-model="value['value'].value" :id="value['correspond'] + '_input'"></textarea>
                            <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']" :id="value['correspond'] + '_input'">{{ value['value'].value }}</div>
                            <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']" :class="value['input_class']" :id="value['correspond'] + '_input'">
                                <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
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
    <div v-else class="flex justify-center items-center w-screen h-screen bg-rose-400">You don't have permission to view / edit this lead</div>
</template>

<style>

</style>