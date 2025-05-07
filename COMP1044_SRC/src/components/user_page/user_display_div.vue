<script setup>
    import axios from "axios";
    import {ref} from "vue";

    const response = ref(); // user data

    // referenceable CSS attribute
    const css_class_attributes = {
        user_id: "w-32 px-4 text-center truncate ",
        name: "w-40 px-4 text-center truncate ",
        user_name: "w-50 text-center px-4 truncate ",
        gender: "w-30 px-4 text-center truncate ",
        country: "w-40 px-4 text-center truncate ",
        company: "w-50 px-4 text-center truncate ",
        description: "w-80 px-4 text-center truncate ",
        date: "w-50 px-4 text-center truncate ",

        title_bar: "py-1 overflow-hidden border-r-3 border-b-3 border-pink-700 font-semibold text-lg ",
        title_bar_button: "mx-2 ",

        display_span: "py-2 overflow-hidden "
    }

    // the JS object for all the displayable attributes from database
    // used for manipulating which attribute to display, the CSS, etc.
    const user_display_attributes = {
        user_id: {
            name: "User ID",
            correspond: "user_id",
            table: "crm_user.",
            class: css_class_attributes.user_id,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        user_name: {
            name: "User name",
            correspond: "user_name",
            table: "crm_user.",
            class: css_class_attributes.user_name,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        role_id: {
            name: "Role ID",
            correspond: "role_id",
            table: "crm_user.",
            class: css_class_attributes.name,
            display: ref(false),
            search_by: ref(false),
            search_for: ref("")
        },
        role_name: {
            name: "Role name",
            correspond: "role_name",
            table: "user_role.",
            class: css_class_attributes.name,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
        total_leads: {
            name: "Total leads",
            correspond: "total_leads",
            table: "total_leads",
            class: css_class_attributes.name,
            display: ref(true),
            search_by: ref(false),
            search_for: ref("")
        },
    };

    // check if at least one user display attribute is selected
    const need_display = ref(true);
    // parameter(value): one of the object in user_display_attributes 
    const check_need_display = (value) => {
        // assume no display
        need_display.value = false;
        // loop through the object to see if any display is true
        for (const key in user_display_attributes){
            if (user_display_attributes[key]['display']['value']){
                need_display.value = true;
            } else {
                if (user_display_attributes[key]['correspond'] == sort_attribute.value)
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

        for (const key in user_display_attributes){
            if (user_display_attributes[key]['display']['value']){
                display_attribute.push(user_display_attributes[key]);
            }
        }
        return display_attribute;
    }

    // retrieve all data from TABLE crm_user JOIN user_role, COUNT(individual_id)
    const retrieve_all = async () => {
        try {
            response.value = await axios.post("../backend/retrieve_user_api.php");
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
                for (const value in user_display_attributes){
                    if (user_display_attributes[value]['display']['value'] && user_display_attributes[value]['correspond'] != 'total_leads'){
                        search_array.push(
                            user_display_attributes[value]['correspond'] + ":" +
                            (general_search['value']).trim()
                        );
                    }
                }
            }else{
                for (const value in user_display_attributes){
                    if (user_display_attributes[value]['search_by']['value'] && user_display_attributes[value]['correspond'] != 'total_leads'){
                        search_array.push(
                            user_display_attributes[value]['correspond'] + ":" +
                            (user_display_attributes[value]['search_for']['value']).trim()
                        );
                    }
                }
            }

            response.value = await axios.post(
                // send the request to:
                "../backend/retrieve_user_api.php", 
                {
                    sort: true, // set that it is a sort request
                    sort_attribute: sort_attribute.value, // what attribute to sort by
                    sort_by: sort_order.value, // what order to sort by
                    requirement: JSON.stringify(search_array), // filter the requiremnt, convert the array into string
                    filter: filter_type.value,
                    search_type: search_type,
                    lead_total_search: user_display_attributes['total_leads']['search_by']['value'],
                    lead_total_search_value: user_display_attributes['total_leads']['search_for']['value']
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
        {}
    );

    // the function to call whenever user hover over an user
    const currently_hover = (user) => {
        current_hover_user.value = user;
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

    check_is_login();
    retrieve_all();
</script>

<template>
    <div v-if="is_login">
        <!-- title -->
        <div class="flex justify-center items-center py-2 font-bold text-2xl border-pink-700 border-b-4 bg-pink-500"><span class="py-1 px-6 bg-pink-300 rounded-full">CRM user</span></div>
        <div class="flex min-w-max max-w-screen min-h-min h-screen max-h-screen bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500 overflow-auto justify-center">
            <!-- Display content -->
            <div class="flex flex-col max-h-screen w-180 min-w-180 max-w-180 min-h-160 m-3 border-4 rounded-lg overflow-hidden border-pink-700">
                <div class="flex flex-col h-full overflow-auto last:border-r-0">
                    <div class="flex flex-row w-max min-w-180 min-h-8 bg-pink-500 overflow-hidden last:border-r-0">
                        <div class="flex flex-row w-max last:border-r-0" v-for="value in user_display_attributes" :key="value" v-if="need_display">
                            <div v-if="value['display'].value" v-bind:class="(value['class'] + css_class_attributes.title_bar)">{{ value['name'] }}</div>
                        </div>
                        <div class="flex h-full w-full justify-center items-center" v-else>
                            <span>No attribute selected</span>
                        </div>
                    </div>
                    <div class="flex flex-col w-max overflow-y-auto h-full bg-rose-100" v-if="need_display && JSON.stringify(response.data) != '[]'">
                        <router-link :to="{name: 'user_edit_page', params: {user_id: response_value['user_id']}}" @mouseover="currently_hover(response_value)" class="w-max min-w-180 min-h-10 bg-rose-100 hover:bg-rose-300 flex flex-row border-b-pink-700/80 border-b-1 overflow-hidden" v-if="response.status==200" v-for="response_value in response.data" :key="response_value" v-bind:id="response_value.user_id">
                            <div class="w-max flex overflow-hidden" v-for="value in user_display_attributes" :key="value">   
                                <span v-if="value['display'].value" v-bind:class="value['class'] + css_class_attributes.display_span">{{ response_value[value['correspond']] }}</span>
                            </div>
                        </router-link>
                    </div>
                    <div class="flex bg-red-400 h-full w-full justify-center items-center" v-else-if="!need_display">
                        <span>No content available since no attribute is selected</span>
                    </div>
                    <div class="flex bg-red-400 h-full w-full justify-center items-center" v-if="JSON.stringify(response.data) == '[]'">
                        <span>No user fulfill the search requirement</span>
                    </div>
                </div>

                <!-- Sorting -->
                <div class="flex flex-row bg-pink-500 justify-between items-center p-2 border-pink-700 border-t-3">
                    <div class="flex">
                        <div class="pr-4 font-semibold">Sort by:</div>
                        <select @change="search_data('SPECIFIC')" v-model="sort_attribute" id="select_sort_by">
                            <option disabled value="Please select an option" v-if="need_display">Please select an option</option>
                            <option disabled value="No attribute selected" v-else>No attribute selected</option>
                            <option v-for="value in get_current_display_attribute()" :value="value['correspond']">{{ value['name'] }}</option>
                        </select>
                    </div>
                    <div class="flex justify-between">
                        <div class="flex flex-row px-4">
                            <label for="sort_ascd" class="pl-3">Ascending</label>
                            <input class="accent-pink-700 mx-1" @change="search_data('SPECIFIC')" type="radio" v-model="sort_order" :value="'ASCD'" id="sort_ascd" name="sort_radio" checked/>
                            <label for="sort_desc" class="pl-3">Descending</label>
                            <input class="accent-pink-700 mx-1" @change="search_data('SPECIFIC')" type="radio" v-model="sort_order" :value="'DESC'" id="sort_desc" name="sort_radio"/>
                        </div>
                    </div>
                </div>
            </div>

            <!-- right side -->
            <div class="flex flex-col min-h-max max-h-max w-180 max-w-180 min-w-180 m-2">
                <div class="flex flex-col px-2 py-1 bg-pink-300 border-pink-700 rounded-lg border-3 m-1">
                    <div class="h-max font-bold mx-1 text-xl py-1 decoration-2 decoration-pink-700 underline">Filter Users</div>
                    <div class="flex flex-row h-max">

                        <!-- Select display section -->
                        <div class="flex flex-col min-h-80 max-h-98 w-35/100 border-3 border-pink-700 rounded-xs mx-1 bg-rose-100">
                            <div class="h-max border-pink-700 px-3 py-1 border-b-3 font-bold bg-pink-500">Display</div>
                            <div class="flex flex-col overflow-auto bg-rose-100">
                                <div class="flex flex-row justify-between mx-2 border-b-2 border-pink-700/60 last:border-none" v-for="value in user_display_attributes" :key="value">
                                    <label class="w-full px-1 py-1 mr-2 font-medium" :for="value['correspond'] + '_display_checkbox'">{{ value['name'] }}</label>
                                    <input class="mx-2 accent-pink-700" @click="value['display'].value = !value['display'].value" @change="check_need_display(value)" v-model="value['display'].value" :id="value['correspond'] + '_display_checkbox'" v-bind:name="value['correspond'] + '_display_checkbox'" type="checkbox"/>
                                </div>
                            </div>
                        </div>

                        <!-- Search section -->
                        <div class="flex flex-col min-h-80 max-h-max w-65/100 border-3 border-pink-700 rounded-xs mx-1 bg-red-100">
                            <div class="h-max border-pink-700 px-3 py-1 border-b-3 font-bold bg-pink-500">Search by</div>
                            <div class="bg-pink-500 flex justify-center items-center border-pink-700 border-b-3"><input @input="search_data('GENERAL')" v-model="general_search" class="bg-white w-full rounded-full focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-8 mx-2 my-1 px-4 border-2 border-pink-700 cursor-pointer focus:cursor-text hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content overflow-auto text-nowrap truncate" type="search" placeholder="Search for users that match the requirement..."></div>

                            <!-- Search by check box -->
                            <div class="flex flex-col overflow-auto w-full h-60 bg-rose-100">
                                <div class="last:border-none" v-for="value in user_display_attributes" :key="value">
                                    <div class="mx-2 mt-2 flex flex-row border-pink-700/60 border-b-2 justify-center items-center" v-if="value['display'].value">
                                        <label class="w-45/100 px-2" :for="value['correspond'] + '_search_by_checkbox'">{{ value['name'] }}</label>
                                        <input class="accent-pink-700" @change="search_data" @click="value['search_by'].value = !value['search_by'].value" v-model="value['search_by'].value" :id="value['correspond'] + '_search_by_checkbox'" v-bind:name="value['correspond'] + '_search_by_checkbox'" type="checkbox"/>
                                        <input @input="search_data('SPECIFIC')" class="bg-white w-55/100 rounded-md focus:shadow-pink-500/50 focus:bg-gray-100 shadow-xl h-6 mx-2 my-1 px-2 border-2 border-pink-700 cursor-pointer focus:cursor-text hover:bg-[url(/src/assets/icon/icons8-search.svg)] focus:bg-[url(/src/assets/icon/icons8-search.svg)] bg-no-repeat bg-right bg-size-[5%_auto] bg-origin-content overflow-auto text-nowrap truncate" v-model="value['search_for'].value" type="search"/>
                                    </div>
                                </div>
                            </div>

                            <!-- Filter search type -->
                            <div class="flex flex-row w-full justify-between bg-pink-500 border-pink-700 p-2 border-t-3">
                                <div class="w-max font-semibold ml-3">Filter type:</div>
                                <div class="flex flex-row justify-end w-fit">
                                    <label class="ml-3" for="search_one">Fulfill at least one</label>
                                    <input class="mx-1 accent-pink-700" @change="search_data('SPECIFIC')" type="radio" v-model="filter_type" :value="'OR'" id="search_one" name="search_radio" checked/>
                                    <label class="ml-3" for="search_all">Fulfill all</label>
                                    <input class="mx-1 accent-pink-700" @change="search_data('SPECIFIC')" type="radio" v-model="filter_type" :value="'AND'" id="search_all" name="search_radio"/>
                                </div>
                            </div>

                            <!-- Search button -->
                            <div class="flex flex-row w-full justify-between bg-pink-500">
                                <div class="w-max font-semibold ml-3">Search type:</div>
                                <div class="flex flex-row justify-end w-fit">
                                    <button @click="search_data('GENERAL')" class="bg-pink-200 mx-3 hover:bg-pink-700 hover:text-white rounded-full w-35 px-2 mb-1 font-semibold">General search</button>
                                    <button @click="search_data('SPECIFIC')" class="bg-pink-200 mx-3 hover:bg-pink-700 hover:text-white rounded-full w-35 px-2 mb-1 font-semibold">Specific search</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- create new user -->
                <div class="bg-pink-300 rounded-md border-pink-700 border-3 m-1 h-20 flex justify-end">
                    <router-link class="mx-3 my-4 bg-green-500 py-2 px-4 rounded-full font-bold hover:bg-green-800 hover:text-white" :to="{name: 'user_creation_page'}" tag="button">Create new user</router-link>
                </div>

            </div>
        </div>
    </div>

    <div v-else class="w-screen h-screen flex flex-col bg-pink-300 justify-center items-center">
        <div>Unable to acceess the page due to unauthorized access, please log in to continue</div>
        <router-link class="bg-rose-500 hover:bg-rose-800 font-semibold hover:text-white rounded-full px-6 py-1 m-2" :to="{name: 'login_page'}" tag="button">Login at here</router-link>
    </div>
</template>