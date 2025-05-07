<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    // the parameter passed by the router
    const props = defineProps({
        individual_id: String // for accessing specific individual
    });

    // current crm user
    const current_crm_user = ref("");

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

        normal_edit_attribute: "flex flex-row mb-4 items-center",
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
        relationship: {
            name: "Individual relationship",
            correspond: "relationship",
            table: "individual.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.select_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(relationship_option),
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        assign_to: {
            name: "Assign to user",
            correspond: "lead_owner_user_id",
            table: "lead_individual.",
            class: css_class_attributes.search_select_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.variable_select_input,
            input: input_attributes.variable_select,
            trait: input_attributes.trait_select,
            value: ref(""),
            value_name: ref("user_name"),
            search_value: ref(""),
            search_placeholder: ref("Search for individual name..."),
            search_function: ref(""),
            option_list: ref(assign_to_user_option),
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

    // get current crm user
    const get_current_crm_user = async () => {
        try {
            const get_current_crm_user_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user['value'] = get_current_crm_user_response['data']['user_id'];
            edit_attribute_right['assign_to']['value']['value'] = current_crm_user['value']; // set default assign to user
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
    // bind the function to country
    edit_attribute_left['country']['search_function']['value'] = get_country_option;

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
    edit_attribute_right['assign_to']['search_function']['value'] = get_assign_user_option;

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
                            success_operation_prompt['value'] = true;
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

        // reset error and tooltup
        edit_attribute_left['last_name']['has_error']['value'] = false;
        edit_attribute_left['first_name']['has_error']['value'] = false;
        edit_attribute_left['phone_number']['has_error']['value'] = false;
        edit_attribute_left['email_address']['has_error']['value'] = false;
        edit_attribute_left['gender']['has_error']['value'] = false;
        edit_attribute_left['honorifics']['has_error']['value'] = false;
        edit_attribute_right['relationship']['has_error']['value'] = false;

        // check if last name or first name is filled
        if ((typeof((edit_attribute_left['last_name']['value']['value']).trim()) == "undefined" || (edit_attribute_left['last_name']['value']['value']).trim() == "") && (typeof((edit_attribute_left['first_name']['value']['value']).trim()) == "undefined" || (edit_attribute_left['first_name']['value']['value']).trim() == "")){
            edit_attribute_left['last_name']['has_error']['value'] = true;
            edit_attribute_left['first_name']['has_error']['value'] = true;
            edit_attribute_left['last_name']['tooltip_visible']['value'] = true;
            edit_attribute_left['first_name']['tooltip_visible']['value'] = true;
            edit_attribute_left['last_name']['tooltip_message']['value'] = "Last name and first name cannot be empty at the same time.\nPlease try again.";
            edit_attribute_left['first_name']['tooltip_message']['value'] = "Last name and first name cannot be empty at the same time.\nPlease try again.";
            can_add['value'] = false;
        } else {   
            // test if the input follow the format
            const reg_exp = new RegExp(input_attributes.name_pattern);
            if (!((typeof((edit_attribute_left['last_name']['value']['value']).trim()) == "undefined" || (edit_attribute_left['last_name']['value']['value']).trim() == "")) && !(reg_exp.test(edit_attribute_left['last_name']['value']['value']))){
                edit_attribute_left['last_name']['has_error']['value'] = true;
                edit_attribute_left['last_name']['tooltip_visible']['value'] = true;
                edit_attribute_left['last_name']['tooltip_message']['value'] = "Bad name format, please try again. \n(Name must start with capital letter, and does not include numbers or special character)";
                can_add['value'] = false;
            }

            if (!(typeof((edit_attribute_left['first_name']['value']['value']).trim()) == "undefined" || (edit_attribute_left['first_name']['value']['value']).trim() == "") && !(reg_exp.test(edit_attribute_left['first_name']['value']['value']))){
                edit_attribute_left['first_name']['has_error']['value'] = true;
                edit_attribute_left['first_name']['tooltip_visible']['value'] = true;
                edit_attribute_left['first_name']['tooltip_message']['value'] = "Bad name format, please try again. \n(Name must start with capital letter, and does not include numbers or special character)";
                can_add['value'] = false;
            }
        }

        // check phone number and email has one of them filled
        if ((typeof((edit_attribute_left['phone_number']['value']['value']).trim()) == "undefined" || (edit_attribute_left['phone_number']['value']['value']).trim() == "") && (typeof((edit_attribute_left['email_address']['value']['value']).trim()) == "undefined" || (edit_attribute_left['email_address']['value']['value']).trim() == "")){
            edit_attribute_left['phone_number']['has_error']['value'] = true;
            edit_attribute_left['email_address']['has_error']['value'] = true;
            edit_attribute_left['phone_number']['tooltip_visible']['value'] = true;
            edit_attribute_left['email_address']['tooltip_visible']['value'] = true;
            edit_attribute_left['phone_number']['tooltip_message']['value'] = "Phone number and email address cannot be empty at the same time.\nPlease try again.";
            edit_attribute_left['email_address']['tooltip_message']['value'] = "Phone number and email address cannot be empty at the same time.\nPlease try again.";
            can_add['value'] = false;
        } else {
            // test if the input follow the format
            const reg_exp_phone = new RegExp(input_attributes.phone_pattern);
            const reg_exp_email = new RegExp(input_attributes.email_pattern);
            if (!((typeof((edit_attribute_left['phone_number']['value']['value']).trim()) == "undefined" || (edit_attribute_left['phone_number']['value']['value']).trim() == "")) && !(reg_exp_phone.test(edit_attribute_left['phone_number']['value']['value']))){
                edit_attribute_left['phone_number']['has_error']['value'] = true;
                edit_attribute_left['phone_number']['tooltip_visible']['value'] = true;
                edit_attribute_left['phone_number']['tooltip_message']['value'] = "The entered phone number format is invalid.\nPlease try again. (Format: number between range (8, 20) without special character)";
                can_add['value'] = false;
            } else if (!((typeof((edit_attribute_left['phone_number']['value']['value']).trim()) == "undefined" || (edit_attribute_left['phone_number']['value']['value']).trim() == ""))) {
                const phone_number_response = await axios.post("../backend/retrieve_phone_number_api.php", {phone_number: edit_attribute_left['phone_number']['value']['value']});
                if (phone_number_response.status == 204){

                } else {
                    edit_attribute_left['phone_number']['has_error']['value'] = true;
                    edit_attribute_left['phone_number']['tooltip_visible']['value'] = true;
                    edit_attribute_left['phone_number']['tooltip_message']['value'] = "The entered phone number has already taken by another individual. Please try another number.";
                    can_add['value'] = false;
                }
            }

            if (!(typeof((edit_attribute_left['email_address']['value']['value']).trim()) == "undefined" || (edit_attribute_left['email_address']['value']['value']).trim() == "") && !(reg_exp_email.test(edit_attribute_left['email_address']['value']['value']))){
                edit_attribute_left['email_address']['has_error']['value'] = true;
                edit_attribute_left['email_address']['tooltip_visible']['value'] = true;
                edit_attribute_left['email_address']['tooltip_message']['value'] = "The entered email address format is invalid.\nPlease try again. (Format: 'local-part@domain')";
                can_add['value'] = false;
            } else if (!(typeof((edit_attribute_left['email_address']['value']['value']).trim()) == "undefined" || (edit_attribute_left['email_address']['value']['value']).trim() == "")) {
                const email_address_response = await axios.post("../backend/retrieve_email_address_api.php", {email_address: edit_attribute_left['email_address']['value']['value']});
                if (email_address_response.status == 204){

                } else {
                    edit_attribute_left['email_address']['has_error']['value'] = true;
                    edit_attribute_left['email_address']['tooltip_visible']['value'] = true;
                    edit_attribute_left['email_address']['tooltip_message']['value'] = "The entered email address has already taken by another individual. Please try another email address.";
                    can_add['value'] = false;
                }
            }
        }

        // gender
        if ((typeof((edit_attribute_left['gender']['value']['value']).trim()) == "undefined" || (edit_attribute_left['gender']['value']['value']).trim() == "")){
            edit_attribute_left['gender']['has_error']['value'] = true;
            edit_attribute_left['gender']['tooltip_visible']['value'] = true;
            edit_attribute_left['gender']['tooltip_message']['value'] = "The gender attribute cannot be empty";
            can_add['value'] = false;
        }

        // honorifics
        if ((typeof((edit_attribute_left['honorifics']['value']['value']).trim()) == "undefined" || (edit_attribute_left['honorifics']['value']['value']).trim() == "")){
            edit_attribute_left['honorifics']['has_error']['value'] = true;
            edit_attribute_left['honorifics']['tooltip_visible']['value'] = true;
            edit_attribute_left['honorifics']['tooltip_message']['value'] = "The honorifics attribute cannot be empty";
            can_add['value'] = false;
        }

        // relationship
        if ((typeof((edit_attribute_right['relationship']['value']['value']).trim()) == "undefined" || (edit_attribute_right['relationship']['value']['value']).trim() == "")){
            edit_attribute_right['relationship']['has_error']['value'] = true;
            edit_attribute_right['relationship']['tooltip_visible']['value'] = true;
            edit_attribute_right['relationship']['tooltip_message']['value'] = "The relationship attribute cannot be empty";
            can_add['value'] = false;
        }
    }

    // add the individual into the database
    const create_new_user = async () => {
        await validate_create();

        if (can_add.value){
            var insert_data = [];
            for (const value in edit_attribute_left){
                if (edit_attribute_left[value]['value']['value'] != ""){
                    insert_data.push(edit_attribute_left[value]['correspond'] + ":'" + edit_attribute_left[value]['value']['value'] + "'");
                }
            }
            for (const value in edit_attribute_right){
                if (edit_attribute_right[value]['value']['value'] != "" && (edit_attribute_right[value]['correspond'] != "company_address" && edit_attribute_right[value]['correspond'] != "company_description")){
                    if (edit_attribute_right[value]['correspond'] != 'lead_owner_user_id'){
                        insert_data.push(edit_attribute_right[value]['correspond'] + ":'" + edit_attribute_right[value]['value']['value'] + "'");
                    }
                }
            }

            try {
                if (edit_attribute_right['relationship']['value']['value'] != "Lead"){
                    const create_individual_response = await axios.post(
                        "../backend/create_new_individual_api.php",
                        {
                            requirement: JSON.stringify(insert_data),
                            relationship: edit_attribute_right['relationship']['value']['value']
                        }
                    );
                    if (create_individual_response.status == 204){
                        create_success_prompt['value'] = true;
                    }
                } else {
                    const create_individual_response = await axios.post(
                        "../backend/create_new_individual_api.php",
                        {
                            requirement: JSON.stringify(insert_data),
                            relationship: edit_attribute_right['relationship']['value']['value'],
                            lead_owner_user_id: edit_attribute_right['assign_to']['value']['value']
                        }
                    );
                    if (create_individual_response.status == 204){
                        create_success_prompt['value'] = true;
                    }
                }
            } catch (error){
                alert(error);
            }
        }
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
        get_gender_option();
        get_honorifics_option();
        get_assign_user_option();
        get_company_option();
        get_country_option();
        get_relationship_option();
        check_is_login();
    }

    initialize();
</script>

<template>
    <div class="flex flex-col w-max h-max" v-if="is_login">
        <!-- sticky top bar -->
        <div class="flex flex-row items-center justify-between min-w-screen max-w-full h-14 z-5 bg-fuchsia-400 border-b-3 border-pink-700 sticky top-0 shadow-xl">
            <router-link :to="{name: 'lead_page'}" tag="button"><div class="w-10 h-10 bg-[url(/src/assets/icon/back-svgrepo-com.svg)] bg-size-[100%] mx-4 rounded-full hover:bg-rose-50"></div></router-link>
            <div class="text-2xl font-semibold bg-rose-100 px-6 py-1 rounded-full text-pink-800">Individual creation page</div>
            <button @click="create_prompt = true; create_new_user();" class="text-white font-semibold bg-green-600 hover:bg-green-800 hover:text-fuchsia-50 mx-4 text-xl px-6 py-1 rounded-full">Create</button>
        </div>

        <div v-if="create_success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The individual has successfully been created</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <router-link :to="{name: 'lead_page'}" tag="button"><button @click="create_success_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button></router-link>
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
                                    <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" :pattern="value['pattern']" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]"  v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                                    <textarea @input="value['changed'].value = true" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed']['value']== true))" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" v-model="value['value'].value" :id="value['correspond'] + '_input'"></textarea>
                                    <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']" :id="value['correspond'] + '_input'">{{ value['value'].value }}</div>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" :id="value['correspond'] + '_input'">
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
                            </div>
                        </div>

                        <!-- data at right side -->
                        <div :class="css_class_attributes.edit_attribute_area">
                            <div :class="value['class']" v-for="value in edit_attribute_right" :key="value">
                                <label v-if="value['correspond'] != 'lead_owner_user_id' || edit_attribute_right['relationship']['value']['value'] == 'Lead'" :for="value['correspond'] + '_input'" :class="value['name_class']"><div>{{ value['name'] }}</div></label>
                                <!-- the input field -->
                                <div class="relative">
                                    <input maxlength="25" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" :pattern="value['pattern']" @input="value['changed'].value = true" v-if="value['input'] == 'text'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]"  v-model="value['value'].value" :type="value['input']" :id="value['correspond'] + '_input'"/>
                                    <textarea @input="value['changed'].value = true" @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-else-if="((value['input'] == 'textarea' && value['correspond'] != 'conversion_message') || (value['correspond'] == 'conversion_message' && value['changed']['value']== true))" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" v-model="value['value'].value" :id="value['correspond'] + '_input'"></textarea>
                                    <div v-else-if="value['input'] == 'paragraph'" :class="value['input_class']" :id="value['correspond'] + '_input'">{{ value['value'].value }}</div>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-else-if="value['input'] == 'fixed_select'" v-model="value['value']['value']" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" :id="value['correspond'] + '_input'">
                                        <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
                                    </select>
                                    <!-- tooltip content-->
                                    <div v-if="value['has_error'].value" :class="[value['tooltip_visible'].value, css_class_attributes.tooltip]">{{ value['tooltip_message'].value }}</div>
                                </div>
                                <!-- for searchable select -->
                                <div v-if="value['correspond'] != 'lead_owner_user_id'" class="flex flex-col">
                                    <input @input="value['search_function']['value'](value['search_value']['value'])" v-if="value['input'] == 'variable_select'" type="search" :id="value['correspond'] + '_input'" :class="css_class_attributes.search_input" :placeholder="value['search_placeholder']['value']" v-model="value['search_value']['value']"/>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-if="value['input'] == 'variable_select'" v-model="value['value']['value']" :class="value['input_class']">
                                        <option :class="css_class_attributes.option_input" v-for="option in value['option_list']['value']" :value="option[value['correspond']]"> {{ option[value['value_name']['value']] }} </option>
                                        <option :class="css_class_attributes.option_input" :value="null">NULL</option>
                                    </select>
                                </div>
                                <!-- for assign user -->
                                <div v-if="edit_attribute_right['relationship']['value']['value'] == 'Lead' && value['correspond'] == 'lead_owner_user_id'" class="flex flex-col">
                                    <input @input="value['search_function']['value'](value['search_value']['value'])" v-if="value['input'] == 'variable_select'" type="search" :id="value['correspond'] + '_input'" :class="css_class_attributes.search_input" :placeholder="value['search_placeholder']['value']" v-model="value['search_value']['value']"/>
                                    <select @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" @change="select_changed(value)" v-if="value['input'] == 'variable_select'" v-model="value['value']['value']" :class="value['input_class']">
                                        <option :class="css_class_attributes.option_input" v-for="option in value['option_list']['value']" :value="option['user_id']">ID: {{ option['user_id'] }} - User name: {{ option[value['value_name']['value']] }} </option>
                                        <option :class="css_class_attributes.option_input" :value="current_crm_user">Self</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <div v-else class="w-screen h-screen flex flex-col bg-pink-300 justify-center items-center">
        <div>Unable to acceess the page due to unauthorized access, please log in to continue</div>
        <router-link class="bg-rose-500 hover:bg-rose-800 font-semibold hover:text-white rounded-full px-6 py-1 m-2" :to="{name: 'login_page'}" tag="button">Login at here</router-link>
    </div>
</template>

<style>

</style>