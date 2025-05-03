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
        time_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-md cursor-pointer px-2 overflow-auto text-nowrap truncate shadow-xl",
        paragraph_input: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-40 mx-3 px-2 py-1 overflow-auto border-2 focus:bg-gray-100 border-pink-700 rounded-md bg-white shadow-xl",
        paragraph_input_short: "focus:shadow-pink-500/50 shadow-xl flex w-100 h-20 mx-3 px-2 py-1 overflow-y-scroll focus:bg-gray-100 border-2 border-pink-700 rounded-sm bg-white",
        variable_select_input: "h-8 w-100 mx-3 bg-white border-pink-700 border-2 rounded-sm cursor-pointer px-2 pr-5 hover:bg-[url(/src/assets/icon/pen-solid.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        option_input: "",
        search_input: "focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-8 w-100 mx-3 mb-2 bg-white rounded-full border-2 border-pink-700 cursor-pointer focus:cursor-text px-2 hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",
        small_search_input: "focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-8 w-80 mx-3 mb-2 bg-white rounded-full border-2 border-pink-700 cursor-pointer focus:cursor-text px-2 hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content invalid:shadow-red-600 overflow-auto text-nowrap truncate",

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
        activity_subject: {
            name: "Activity subject",
            correspond: "activity_subject",
            table: "activity.",
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
        activity_type: {
            name: "Activity type",
            correspond: "activity_type",
            table: "activity.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.select_input,
            input: input_attributes.fixed_select,
            trait: input_attributes.trait_select,
            option_list: ref(activity_type_option),
            value: ref("Other"),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        start_time: {
            name: "Start time",
            correspond: "start_time",
            table: "activity.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.time_input,
            input: input_attributes.datetime,
            trait: input_attributes.trait_select,
            option_list: ref(honorifics_option),
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        end_time: {
            name: "End time",
            correspond: "end_time",
            table: "activity.",
            class: css_class_attributes.normal_edit_attribute,
            name_class: css_class_attributes.normal_label,
            input_class: css_class_attributes.time_input,
            input: input_attributes.datetime,
            trait: input_attributes.trait_select,
            option_list: ref(honorifics_option),
            value: ref(""),
            hover: ref(false),
            changed: ref(false),
            has_error: ref(false),
            tooltip_visible: ref(css_class_attributes.tooltip_hide),
            tooltip_message: ref("")
        },
        activity_description: {
            name: "Activity description",
            correspond: "activity_description",
            table: "activity.",
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

    // get current crm user
    const get_current_crm_user = async () => {
        try {
            const get_current_crm_user_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user['value'] = get_current_crm_user_response['data']['user_id'];
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

    // get individual list
    const get_individual_add_list = async (search_value) => {
        try {
            individual_add_list['value'] = [];
            const get_individual_add_list_response = await axios.post("../backend/retrieve_activity_individual_option_api.php");

            // check for duplicate
            for (const add_value in get_individual_add_list_response['data']){
                var add_to = true;
                for (const drop_value in individual_drop_list['value']){
                    if (get_individual_add_list_response['data'][add_value]['individual_id'] == individual_drop_list['value'][drop_value]['individual_id']){
                        add_to = false;
                        break;
                    }
                }
                if (add_to)
                    individual_add_list['value'].push(get_individual_add_list_response['data'][add_value]);
            }
        } catch (error) {
            alert(error);
        }
    }

    // add to participant list
    const add_participant = (individual) => {
        individual_drop_list['value'].push(individual);
        for (const value in individual_add_list['value']){
            if (individual_add_list['value'][value]['individual_id'] == individual['individual_id']){
                individual_add_list['value'].splice(value, 1);
            }
        }
    }
    
    // drop pacticipant
    const drop_participant = (individual) => {
        for (const value in individual_drop_list['value']){
            if (individual_drop_list['value'][value]['individual_id'] == individual['individual_id']){
                individual_drop_list['value'].splice(value, 1);
            }
        }
        get_individual_add_list();
    }

    // validate the creation of an individual
    const can_add = ref(true);
    // validate add activity
    const validate_create = async () => {
        can_add['value'] = true;

        // reset error and tooltip
        edit_attribute_left['activity_subject']['has_error']['value'] = false;
        edit_attribute_left['start_time']['has_error']['value'] = false;
        edit_attribute_left['end_time']['has_error']['value'] = false;

        if ((typeof((edit_attribute_left['activity_subject']['value']['value']).trim()) == "undefined") || (edit_attribute_left['activity_subject']['value']['value']).trim() == ""){
            edit_attribute_left['activity_subject']['has_error']['value'] = true;
            edit_attribute_left['activity_subject']['tooltip_visible']['value'] = true;
            edit_attribute_left['activity_subject']['tooltip_message']['value'] = "Activity subject cannot be empty";
            can_add['value'] = false;
        }

        if ((typeof((edit_attribute_left['end_time']['value']['value']).trim()) == "undefined") || (edit_attribute_left['end_time']['value']['value']).trim() == ""){
            edit_attribute_left['end_time']['has_error']['value'] = true;
            edit_attribute_left['end_time']['tooltip_visible']['value'] = true;
            edit_attribute_left['end_time']['tooltip_message']['value'] = "Activity end time cannot be empty value /\nThe filled in end time is not complete";
            can_add['value'] = false;
        } else {
            if (edit_attribute_left['start_time']['value']['value'] > edit_attribute_left['end_time']['value']['value']){
                edit_attribute_left['end_time']['has_error']['value'] = true;
                edit_attribute_left['end_time']['tooltip_visible']['value'] = true;
                edit_attribute_left['end_time']['tooltip_message']['value'] = "Activity end time cannot be earlier than activity start time";
                can_add['value'] = false;
            }
        }

        if (can_add['value']){
            let start_time = "";
            let end_time = "'" + edit_attribute_left['end_time']['value']['value'] + "'";
            let description = "";

            let activity_id = "";

            if ((typeof((edit_attribute_left['start_time']['value']['value']).trim()) == "undefined") || (edit_attribute_left['start_time']['value']['value']).trim() == ""){
                start_time = 'null';
            } else {
                start_time = "'" + edit_attribute_left['start_time']['value']['value'] + "'";
            }

            if ((typeof((edit_attribute_left['activity_description']['value']['value']).trim()) == "undefined") || (edit_attribute_left['activity_description']['value']['value']).trim() == ""){
                description = 'null';
            } else {
                description = "'" + edit_attribute_left['activity_description']['value']['value'] + "'";
            }

            try {
                const create_activity_response = await axios.post(
                    "../backend/create_new_activity_api.php",
                    {
                        type: "create",
                        activity_subject: "'" + edit_attribute_left['activity_subject']['value']['value'] + "'",
                        activity_type: "'" + edit_attribute_left['activity_type']['value']['value'] + "'",
                        activity_description: description,
                        start_time: start_time,
                        end_time: end_time
                    }
                );

                if (create_activity_response.status != 400){
                    activity_id = create_activity_response.data.activity_id;
                }
                
                for (const value in individual_drop_list['value']){
                    const insert_individual_activity = await axios.post(
                        "../backend/insert_individual_activity_api.php",
                        {
                            type: "insert",
                            individual_id: individual_drop_list['value'][value]['individual_id'],
                            activity_id: activity_id
                        }
                    )
                }
            } catch (error){
                alert(error);
            }
        }
    }

    // initialize / update to get data
    const initialize = async () => {
        get_current_crm_user();
        get_activity_option();
        get_individual_add_list();
    }

    initialize();
</script>

<template>
    <div class="flex flex-col w-max h-max">
        <!-- sticky top bar -->
        <div class="flex flex-row items-center justify-between min-w-screen max-w-full h-14 z-5 bg-fuchsia-400 border-b-3 border-pink-700 sticky top-0 shadow-xl">
            <router-link :to="{name: 'lead_page'}" tag="button"><div class="w-10 h-10 bg-[url(/src/assets/icon/back-svgrepo-com.svg)] bg-size-[100%] mx-4 rounded-full hover:bg-rose-50"></div></router-link>
            <div class="text-2xl font-semibold bg-rose-100 px-6 py-1 rounded-full text-pink-800">Activity creation page</div>
            <button @click="create_prompt = true; validate_create()" class="text-white font-semibold bg-green-600 hover:bg-green-800 hover:text-fuchsia-50 mx-4 text-xl px-6 py-1 rounded-full">Create</button>
        </div>

        <div v-if="create_success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">The activity has successfully been created</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="create_success_prompt = false" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button>
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
                                        <option v-for="option in value['option_list']['value']" :value="option">{{ option }}</option>
                                    </select>
                                    <input @mouseover="value['tooltip_visible'].value = css_class_attributes.tooltip_show" @mouseleave="value['tooltip_visible'].value = css_class_attributes.tooltip_hide" v-model="value['value']['value']" v-else-if="value['input'] == 'datetime-local'" :class="[value['input_class'], {'shadow-red-600':value['has_error']['value']}]" type="datetime-local"/>
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

                <!-- add participant -->
                <div class="flex flex-col bg-pink-500 m-4 justify-center border-3 rounded-md border-pink-700 shadow-xl">
                    <!-- title --> 
                    <div class="flex flex-row w-full"><span class="font-bold text-lg mx-4 my-2 px-6 py-1 bg-pink-300 border-pink-700 border-3 rounded-sm">Participant</span></div>
                    
                    <!-- add and drop participant -->
                    <div class="flex flex-row justify-between border-pink-700 border-t-3">
                        <!-- add -->
                        <div class="flex flex-col items-center bg-pink-300 border-pink-700 border-r-2 w-1/2">
                            <div class="flex justify-center my-1 font-semibold decoration-2 decoration-pink-700 underline">Add participant</div>
                            <div class="flex">
                                <input :class="css_class_attributes.small_search_input" type="search" placeholder="Search for individual to add..."/>
                            </div>
                            <div class="flex flex-col mx-4 my-1 mb-3 w-80 overflow-auto bg-rose-100 h-100 border-rose-700 rounded-md border-2">
                                <div class="flex justify-between px-2 py-1 hover:bg-rose-300 cursor-default border-rose-700 border-b-1 last:border-none" v-for="value in individual_add_list">
                                    <div class="truncate">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['last_name'] }} {{ value['first_name'] }}</div>
                                    <button @click="add_participant(value)" class="cursor-pointer px-2 rounded-full font-semibold bg-green-500 hover:bg-green-700 hover:text-white">Add</button>
                                </div>
                            </div>
                        </div>

                        <!-- drop -->
                        <div class="flex flex-col items-center bg-pink-300 border-pink-700 border-l-2 w-1/2">
                            <div class="flex justify-center my-1 font-semibold decoration-2 decoration-pink-700 underline">Drop participant</div>
                            <div class="flex">
                                <input :class="css_class_attributes.small_search_input" type="search" placeholder="Search for individual to add..."/>
                            </div>
                            <div class="flex flex-col mx-4 my-1 mb-3 w-80 overflow-auto bg-rose-100 h-100 border-rose-700 rounded-md border-2">
                                <div class="flex justify-between px-2 py-1 hover:bg-rose-300 cursor-default border-rose-700 border-b-1 last:border-none" v-for="value in individual_drop_list">
                                    <div class="truncate">{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['last_name'] }} {{ value['first_name'] }}</div>
                                    <button @click="drop_participant(value)" class="cursor-pointer px-2 rounded-full font-semibold bg-red-500 hover:bg-red-700 hover:text-white">Remove</button>
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