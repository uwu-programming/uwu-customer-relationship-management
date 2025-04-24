<script setup>
    import axios from "axios";
    import {callWithAsyncErrorHandling, ref} from "vue";

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
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        honorifics: {
            name: "Honorifics",
            correspond: "honorifics",
            table: "individual.",
            class: css_class_attributes.honorifics,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        last_name: {
            name: "Last name",
            correspond: "last_name",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        middle_name: {
            name: "Middle name",
            correspond: "middle_name",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        first_name: {
            name: "First name",
            correspond: "first_name",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        company_name: {
            name: "Company name",
            correspond: "company_name",
            table: "company.",
            class: css_class_attributes.company,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        lead_status: {
            name: "Lead status",
            correspond: "lead_status",
            table: "lead_individual.",
            class: css_class_attributes.company,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        phone_number: {
            name: "Phone number",
            correspond: "phone_number",
            table: "individual.",
            class: css_class_attributes.name,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        email_address: {
            name: "Email address",
            correspond: "email_address",
            table: "individual.",
            class: css_class_attributes.company,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        gender: {
            name: "Gender",
            correspond: "gender",
            table: "individual.",
            class: css_class_attributes.gender,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        country: {
            name: "Country",
            correspond: "country_name",
            table: "country.",
            class: css_class_attributes.country,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        company_address: {
            name: "Company address",
            correspond: "company_address",
            table: "company.",
            class: css_class_attributes.description,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        company_description: {
            name: "Company description",
            correspond: "company_description",
            table: "company.",
            class: css_class_attributes.description,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        individual_description: {
            name: "Individual description",
            correspond: "individual_description",
            table: "individual.",
            class: css_class_attributes.description,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        registered_date: {
            name: "Registered date",
            correspond: "registered_date",
            table: "individual.",
            class: css_class_attributes.date,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        }
    };

    // attributes for preview
    const preview_attribute_name = {
        name: {
            name: "Name",
            correspond: "last_name",
            table: "individual.",
            class: ""
        }
    }

    const preview_attribute_left = {
        phone_number: {
            name: "Phone number",
            correspond: "phone_number",
            table: "individual.",
            class: ""
        },
        email_address: {
            name: "Email address",
            correspond: "email_address",
            table: "individual.",
            class: ""
        }
    }

    const preview_attribute_right = {
        lead_status: {
            name: "Lead status",
            correspond: "lead_status",
            table: "lead_individual.",
            class: ""
        },
        country: {
            name: "Country",
            correspond: "country_name",
            table: "country.",
            class: ""
        },
        company_name: {
            name: "Company name",
            correspond: "company_name",
            table: "company.",
            class: ""
        }
    }

    const preview_attribute_description = {
        individual_description: {
            name: "Individual description",
            correspond: "individual_description",
            table: "individual.",
            class: ""
        },
        company_description: {
            name: "Company description",
            correspond: "company_description",
            table: "company.",
            class: ""
        }
    }

    // check if at least one lead display attribute is selected
    const need_display = ref(true);
    // parameter(value): one of the object in lead_display_attributes 
    const check_need_display = (value) => {
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

        // set the search_by value of the passed object to false, and empty search requirement
        value['search_by']['value'] = false;
        value['search_for']['value'] = "";

        search_data("SPECIFIC");
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
            response.value = await axios.post("../backend/retrieve_lead_api.php");
        } catch (error){
            alert(error);
        }
    };

    // record general searching
    const general_search = ref("");
    // record ascending or descending
    const sort_attribute = ref("Please select an option");
    const sort_order = ref("ASCD");

    // send request to filter out the data
    const search_data = async (search_type) => {
        try {
            // search requirement
            var search_array = [];

            // check the search type
            if (search_type == 'GENERAL'){
                for (const value in lead_display_attributes){
                    if (lead_display_attributes[value]['display']['value']){
                        search_array.push(
                            lead_display_attributes[value]['table'] +
                            lead_display_attributes[value]['correspond'] + ":" +
                            (general_search['value']).trim()
                        );
                    }
                }
            }else{
                for (const value in lead_display_attributes){
                    if (lead_display_attributes[value]['search_by']['value']){
                        search_array.push(
                            lead_display_attributes[value]['table'] +
                            lead_display_attributes[value]['correspond'] + ":" +
                            (lead_display_attributes[value]['search_for']['value']).trim()
                        );
                    }
                }
            }

            response.value = await axios.post(
                // send the request to:
                "../backend/retrieve_lead_api.php", 
                {
                    sort: true, // set that it is a sort request
                    sort_attribute: sort_attribute.value, // what attribute to sort by
                    sort_by: sort_order.value, // what order to sort by
                    requirement: JSON.stringify(search_array), // filter the requiremnt, convert the array into string
                    filter: filter_type.value,
                    search_type: search_type
                }
            );
        } catch (error){
            alert(error);
        }
    };

    // keep track the type of filter
    const filter_type = ref("OR");

    // the reference to keep track of current hovered user
    const current_hover_user = ref(
        {
            last_name: "",
            middle_name: "",
            first_name_name: "",
            lead_status: "",
            phone_number: "",
            email_address: "",
            country: "",
            company_name: "",
            individual_description: "",
            company_description: ""
        }
    );

    // the function to call whenever user hover over an individual
    const currently_hover = (individual) => {
        current_hover_user.value = individual;
    }

    // the function to call when 'edit' button is clicked (pass the selected individual_id)
    const set_edit_individual = () => {
        
    }

    retrieve_all();
</script>

<template>
    <div class="flex h-full w-full bg-black overflow-auto">
        <div class="flex flex-col h-9/10 w-55/100 min-w-180 max-w-max m-2 border-1">
            <div class="flex flex-col h-full rounded-2xl border-1 overflow-auto">
                <div class="flex flex-row w-max min-w-180 min-h-8 bg-fuchsia-500 border-b-2">
                    <div class="flex flex-row w-max" v-for="value in lead_display_attributes" :key="value" v-if="need_display">
                        <div v-if="value['display'].value" v-bind:class="(value['class'] + css_class_attributes.title_bar)">{{ value['name'] }}</div>
                    </div>
                    <div class="flex h-full w-full justify-center items-center" v-else>
                        <span>No attribute selected</span>
                    </div>
                </div>
                <div class="flex flex-col w-max overflow-y-auto h-full" v-if="need_display && JSON.stringify(response.data) != '[]'">
                    <button @mouseover="currently_hover(response_value)" class="w-max min-w-180 min-h-10 bg-sky-500 hover:bg-cyan-300 flex flex-row border-b-gray-300/80 border-b-1" v-if="response.status==200" v-for="response_value in response.data" :key="response_value" v-bind:id="response_value.individual_id">
                        <div class="w-max flex" v-for="value in lead_display_attributes" :key="value">   
                            <span v-if="value['display'].value" v-bind:class="value['class'] + css_class_attributes.display_span">{{ response_value[value['correspond']] }}</span>
                        </div>
                    </button>
                </div>
                <div class="flex bg-red-400 h-full w-full justify-center items-center" v-else-if="!need_display">
                    <span>No content available since no attribute is selected</span>
                </div>
                <div class="flex bg-red-400 h-full w-full justify-center items-center" v-if="JSON.stringify(response.data) == '[]'">
                    <span>No lead fulfill the search requirement</span>
                </div>
            </div>

            <!-- Sorting -->
            <div class="flex flex-row bg-rose-600">
                <div class="">Sort by:</div>
                <select @change="search_data('SPECIFIC')" v-model="sort_attribute" id="select_sort_by">
                    <option disabled value="Please select an option" v-if="need_display">Please select an option</option>
                    <option disabled value="No attribute selected" v-else>No attribute selected</option>
                    <option v-for="value in get_current_display_attribute()" :value="value['table'] + value['correspond']">{{ value['name'] }}</option>
                </select>
                <div class="flex flex-row">
                    <label for="sort_ascd">Ascending</label>
                    <input @change="search_data('SPECIFIC')" type="radio" v-model="sort_order" :value="'ASCD'" id="sort_ascd" name="sort_radio" checked/>
                    <label for="sort_desc">Descending</label>
                    <input @change="search_data('SPECIFIC')" type="radio" v-model="sort_order" :value="'DESC'" id="sort_desc" name="sort_radio"/>
                </div>
            </div>
        </div>

        <div class="flex flex-col h-9/10 w-45/55 bg-violet-500 m-2">
            <div class="flex flex-col px-2 py-1 bg-rose-700 h-45/100">
                <div class="">Filter Leads</div>
                <div class="flex flex-row h-full">

                    <!-- Select display section -->
                    <div class="flex flex-col h-full w-3/10">
                        <div class="bg-amber-500">Display</div>
                        <div class="flex flex-col overflow-auto h-full bg-green-500">
                            <div v-for="value in lead_display_attributes" :key="value">
                                <label :for="value['correspond'] + '_display_checkbox'">{{ value['name'] }}</label>
                                <input @click="value['display'].value = !value['display'].value" @change="check_need_display(value)" v-model="value['display'].value" :id="value['correspond'] + '_display_checkbox'" v-bind:name="value['correspond'] + '_display_checkbox'" type="checkbox"/>
                            </div>
                        </div>
                    </div>

                    <!-- Search section -->
                    <div class="flex flex-col h-full w-7/10">
                        <div class="bg-amber-500">Search by</div>
                        <div class=""><input @input="search_data('GENERAL')" v-model="general_search" class="bg-white w-full" type="search"></div>

                        <!-- Search by check box -->
                        <div class="flex flex-col overflow-auto w-full bg-green-500 h-6/10">
                            <div class="flex flex-row" v-for="value in lead_display_attributes" :key="value">
                                <label class="w-3/10" v-if="value['display'].value" :for="value['correspond'] + '_search_by_checkbox'">{{ value['name'] }}</label>
                                <input v-if="value['display'].value" @change="search_data" @click="value['search_by'].value = !value['search_by'].value" v-model="value['search_by'].value" :id="value['correspond'] + '_search_by_checkbox'" v-bind:name="value['correspond'] + '_search_by_checkbox'" type="checkbox"/>
                                <input @input="search_data('SPECIFIC')" class="bg-gray-300 w-7/10" v-model="value['search_for'].value" v-if="value['display'].value" type="search"/>
                            </div>
                        </div>

                        <!-- Filter search type -->
                        <div class="flex flex-row w-full justify-between min-h-max max-h-max">
                            <div class="w-max">Filter type:</div>
                            <div class="flex flex-row justify-end w-fit">
                                <label for="search_one">Fulfill at least one</label>
                                <input @change="search_data('SPECIFIC')" type="radio" v-model="filter_type" :value="'OR'" id="search_one" name="search_radio" checked/>
                                <label for="search_all">Fulfill all</label>
                                <input @change="search_data('SPECIFIC')" type="radio" v-model="filter_type" :value="'AND'" id="search_all" name="search_radio"/>
                            </div>
                        </div>

                        <!-- Search button -->
                         <div class="flex flex-row w-full justify-end min-h-max max-h-max">
                            <button @click="search_data('GENERAL')" class="bg-pink-400 ml-3 hover:bg-pink-700">General search</button>
                            <button @click="search_data('SPECIFIC')" class="bg-pink-400 ml-3 hover:bg-pink-700">Specific search</button>
                         </div>
                    </div>
                </div>
            </div>

            <div class="flex flex-col px-2 py-1 bg-green-600 h-55/100">
                <div>Preview detail</div>
                <div class="flex flex-row">
                    <div class="w-1/2 h-full bg-sky-900 flex flex-col">
                        <div class="">{{ preview_attribute_name['name']['name'] }}: {{ current_hover_user['last_name'] }} {{ current_hover_user['middle_name'] }} {{ current_hover_user['first_name'] }}</div>
                        <div v-for="value in preview_attribute_left" :key="value">{{ value['name'] }}: {{ current_hover_user[value['correspond']] }}</div>
                        <div class="flex flex-col">
                            {{ preview_attribute_description['individual_description']['name'] }}:
                            <div class="flex overflow-auto h-40">{{ current_hover_user[preview_attribute_description['individual_description']['correspond']] }}</div>
                        </div>
                    </div>
                    <div class="w-1/2 bg-sky-900">
                        <div v-for="value in preview_attribute_right" :key="value">{{ value['name'] }}: {{ current_hover_user[value['correspond']] }}</div>
                        <div class="flex flex-col">
                            {{ preview_attribute_description['company_description']['name'] }}:
                            <div class="flex overflow-auto h-40">{{ current_hover_user[preview_attribute_description['company_description']['correspond']] }}</div>
                        </div>
                    </div>
                </div>
                <div class="flex flex-row bg-cyan-700">
                    <router-link @click="set_edit_individual" to="/" tag="button">Edit</router-link>
                </div>
            </div>

            <div>

            </div>
        </div>
    </div>
</template>