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

        title_bar: "border-r-1 py-1 ",
        title_bar_button: "mx-2 ",

        display_span: "py-2 "
    }

    // the JS object for all the displayable attributes from database
    // used for manipulating which attribute to display, the CSS, etc.
    const lead_display_attributes = {
        individual_id: {
            name: "Individual ID",
            correspond: "individual_id",
            table: "individual.",
            class: css_class_attributes.individual_id,
            display: ref(false)
        },
        honorifics: {
            name: "Honorifics",
            correspond: "honorifics",
            table: "individual.",
            class: css_class_attributes.honorifics,
            display: ref(false)
        },
        last_name: {
            name: "Last name",
            correspond: "last_name",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(true)
        },
        middle_name: {
            name: "Middle name",
            correspond: "middle_name",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(false)
        },
        first_name: {
            name: "First name",
            correspond: "first_name",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(true)
        },
        company_name: {
            name: "Company name",
            correspond: "company_name",
            table: "company.",
            class: css_class_attributes.company,
            display: ref(true)
        },
        phone_number: {
            name: "Phone number",
            correspond: "phone_number",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(true)
        },
        email_address: {
            name: "Email address",
            correspond: "email_address",
            table: "individual.",
            class: css_class_attributes.company,
            display: ref(true)
        },
        gender: {
            name: "Gender",
            correspond: "gender",
            table: "individual.",
            class: css_class_attributes.gender,
            display: ref(false)
        },
        country: {
            name: "Country",
            correspond: "country_name",
            table: "country.",
            class: css_class_attributes.country,
            display: ref(false)
        },
        company_address: {
            name: "Company address",
            correspond: "company_address",
            table: "company.",
            class: css_class_attributes.description,
            display: ref(false)
        },
        company_description: {
            name: "Company description",
            correspond: "company_description",
            table: "company.",
            class: css_class_attributes.description,
            display: ref(false)
        },
        individual_description: {
            name: "Individual description",
            correspond: "individual_description",
            table: "individual.",
            class: css_class_attributes.description,
            display: ref(false)
        },
        registered_date: {
            name: "Registered date",
            correspond: "registered_date",
            table: "individual.",
            class: css_class_attributes.date,
            display: ref(false)
        }
    };

    // check if at least one lead display attribute is selected
    const need_display = ref(true);
    const check_need_display = () => {
        // assume no display
        need_display.value = false;
        // loop through the object to see if any display is true
        for (const key in lead_display_attributes){
            if (lead_display_attributes[key]['display']['value']){
                need_display.value = true;
            } else {
                if (lead_display_attributes[key]['correspond'] == sort_attribute.value)
                    sort_attribute.value = "Please select an option";
            }
        }

        if (sort_attribute.value == "No attribute selected" && need_display.value)
            sort_attribute.value = "Please select an option";
        if (!need_display.value)
            sort_attribute.value = "No attribute selected";

        sort_data();
    }

    const get_current_display_attribute = () => {
        const display_attribute = [];

        for (const key in lead_display_attributes){
            if (lead_display_attributes[key]['display']['value']){
                display_attribute.push(lead_display_attributes[key]);
            }
        }
        return display_attribute;
    }

    // retrieve all data from TABLE individual JOIN company
    const retrieve_all = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {sort: false});
        } catch (error){
            alert(error);
        }
    };

    // record ascending or descending
    const sort_attribute = ref("Please select an option");
    const sort_order = ref("ASCD");
    // sort the data by order of an attribute
    const sort_data = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_lead_api.php", {sort: true, sort_attribute: sort_attribute.value, sort_by: sort_order.value});
        } catch (error){
            alert(error);
        }
    };

    retrieve_all();
</script>

<template>
    <div class="flex h-full w-full bg-black overflow-auto">
        <div class="flex flex-col h-9/10 w-55/100 min-w-180 max-w-max m-2 rounded-2xl border-1 overflow-auto">
            <div class="flex flex-row w-max min-w-180 min-h-8 bg-fuchsia-500 border-b-2">
                <div class="flex flex-row w-max" v-for="value in lead_display_attributes" :key="value" v-if="need_display">
                    <div v-if="value['display'].value" v-bind:class="(value['class'] + css_class_attributes.title_bar)">{{ value['name'] }}</div>
                </div>
                <div class="flex h-full w-full justify-center items-center" v-else>
                    <span>No attribute selected</span>
                </div>
            </div>
            <div class="flex flex-col w-max overflow-y-auto h-full" v-if="need_display">
                <button class="w-max min-w-180 min-h-10 bg-sky-500 hover:bg-cyan-300 flex flex-row border-b-gray-300/80 border-b-1" v-if="response.status==200" v-for="response_value in response.data" :key="response_value" v-bind:id="response_value.individual_id">
                    <div class="w-max flex" v-for="value in lead_display_attributes" :key="value">   
                        <span v-if="value['display'].value" v-bind:class="value['class'] + css_class_attributes.display_span">{{ response_value[value['correspond']] }}</span>
                    </div>
                </button>
            </div>
            <div class="flex bg-red-400 h-full justify-center items-center" v-else>
                <span>No content available since no attribute is selected</span>
            </div>
        </div>

        <div class="flex flex-col h-9/10 w-45/55 bg-violet-500 m-2">
            <div class="flex flex-col px-2 py-1 bg-rose-700 h-45/100">
                <div class="">Filter Leads</div>
                <div><input class="bg-white" type="text"></div>
                <div class="flex flex-col h-85/100 overflow-auto">
                    <div class="bg-amber-500">Display</div>
                    <div v-for="value in lead_display_attributes" :key="value">
                        <label :for="value['correspond'] + '_checkbox'">{{ value['name'] }} {{ value['display'].value }}</label>
                        <input @click="value['display'].value = !value['display'].value" @change="check_need_display" v-model="value['display'].value" :id="value['correspond'] + '_checkbox'" v-bind:name="value['correspond'] + '_checkbox'" type="checkbox"/>
                    </div>
                </div>
                <div class="flex flex-row">
                    <div class="">Sort by</div>
                    <select @change="sort_data" v-model="sort_attribute" id="select_sort_by">
                        <option disabled value="Please select an option" v-if="need_display">Please select an option</option>
                        <option disabled value="No attribute selected" v-else>No attribute selected</option>
                        <option v-for="value in get_current_display_attribute()" :value="value['table'] + value['correspond']">{{ value['name'] }}</option>
                    </select>
                    <div class="flex flex-row">
                        <label for="sort_ascd">Ascending</label>
                        <input @change="sort_data" type="radio" v-model="sort_order" :value="'ASCD'" id="sort_ascd" name="sort_radio" checked/>
                        <label for="sort_desc">Descending</label>
                        <input @change="sort_data" type="radio" v-model="sort_order" :value="'DESC'" id="sort_desc" name="sort_radio"/>
                    </div>
                </div>
            </div>

            <div class="flex flex-col px-2 py-1 bg-green-600 h-55/100">
                <div>Preview detail</div>
            </div>
        </div>
    </div>
</template>