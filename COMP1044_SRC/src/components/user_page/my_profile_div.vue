<script setup>
    import axios from 'axios';
    import {ref} from 'vue';

    import { useRouter } from "vue-router";

    const router = useRouter();

    // current user
    const current_crm_user = ref("");
    const current_crm_user_data = ref("");
    const current_crm_user_role = ref("");

    // lead data & activity data
    const lead_data = ref("");
    const activity_data = ref("");

    const logout_prompt = ref(false);

    // get current crm user
    const get_current_crm_user = async () => {
        try {
            const get_current_crm_user_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user['value'] = get_current_crm_user_response['data']['user_id'];
            const get_current_crm_user_data_response = await axios.post("../backend/retrieve_user_data_api.php", {type: "user"});
            current_crm_user_data['value'] = get_current_crm_user_data_response['data'];
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

    // get data
    const get_data = async () => {
        try {
            const lead_response = await axios.post(
                "../backend/retrieve_user_data_api.php",
                {
                    type: "lead"
                }
            );

            lead_data.value = lead_response.data;
        } catch (error){
            alert(error);
        }

        try {
            const activity_response = await axios.post(
                "../backend/retrieve_user_data_api.php",
                {
                    type: "activity"
                }
            );

            activity_data.value = activity_response.data;
        } catch (error){
            alert(error);
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

    const logout = async () => {
        await axios.post("../backend/logout_api.php");
        router.push({name: "login_page"});
    }

    // initialize / update to get data
    const initialize = async () => {
        get_current_crm_user();
        get_current_crm_user_role();
        get_data();
        check_is_login();
    }

    initialize();
</script>

<template>
    <div v-if="is_login">
        <div v-if="logout_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
            <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
                <div class="m-4 font-bold text-lg">Are you sure you want to logout?</div>
                <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                    <button @click="logout()" class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Yes</button>
                    <button @click="logout_prompt = false" class="w-28 mx-4 px-6 py-1 bg-red-600 rounded-full hover:text-fuchsia-50 hover:bg-red-800">No</button>
                </div>
            </div>
        </div>

        <!-- title -->
        <div class="flex justify-center items-center py-2 font-bold text-2xl border-pink-700 border-b-4 bg-pink-500">
            <span class="py-1 px-6 bg-pink-300 rounded-full">My profile</span>
        </div>

        <div class="flex flex-col justify-center items-center bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500">
            <div class="flex flex-col w-180 mt-4 bg-rose-100 border-pink-700 border-3 rounded-md">
                <div class="flex flex-row">
                    <div class="flex justify-end items-end mx-3 my-2 w-1/5 font-semibold border-pink-700 border-b-1">User ID</div>
                    <div class="mx-3 my-2 w-4/5 border-pink-700 border-b-1">{{ current_crm_user_data[0]['user_id'] }}</div>
                </div>
                <div class="flex flex-row">
                    <div class="flex justify-end items-end mx-3 my-2 w-1/5 font-semibold border-pink-700 border-b-1">User name</div>
                    <div class="mx-3 my-2 w-4/5 border-pink-700 border-b-1">{{ current_crm_user_data[0]['user_name'] }}</div>
                </div>
                <div class="flex flex-row">
                    <div class="flex justify-end items-end mx-3 my-2 w-1/5 font-semibold border-pink-700 border-b-1">User role</div>
                    <div class="mx-3 my-2 w-4/5 border-pink-700 border-b-1">{{ current_crm_user_data[0]['role_name'] }}</div>
                </div>
            </div>
        </div>

        <div class="flex min-w-max max-w-screen min-h-min h-screen max-h-screen bg-gradient-to-r bg-linear-to-bl from-violet-500 to-fuchsia-500 overflow-auto justify-center">
            <div class="m-4 p-2 flex flex-col min-h-180 w-180 border-pink-700 border-3 rounded-md bg-pink-300">
                <div class="flex flex-col h-1/2 border-pink-700 rounded-md border-3 bg-rose-100 mb-1">
                    <div class="font-bold bg-pink-500 border-b-3 border-pink-700"><div class="flex w-max px-6 text-lg rounded-sm my-2 mx-4 bg-pink-300 border-pink-700 border-3">My lead</div></div>
                    <div class="flex flex-col overflow-auto last:border-none">
                        <router-link class="hover:bg-rose-300 cursor-pointer px-2 py-1 mx-2 mt-1 border-pink-700/60 border-b-2" :to="{name: 'lead_edit_page', params: {individual_id: value['individual_id']}}" v-for="value in lead_data" tag="button"><button class="flex w-full cursor-pointer justify-between"><span>{{ value['individual_id'] }}: {{ value['honorifics'] }} {{ value['first_name'] }} {{ value['last_name'] }}</span><span>{{ value['lead_status'] }}</span></button></router-link>
                    </div>
                </div>
                
                <div class="flex flex-col h-1/2 border-pink-700 rounded-md border-3 bg-rose-100 mt-1">
                    <div class="font-bold bg-pink-500 border-b-3 border-pink-700"><div class="flex w-max px-6 text-lg rounded-sm my-2 mx-4 bg-pink-300 border-pink-700 border-3">My activity</div></div>
                    <div class="flex flex-col overflow-auto last:border-none">
                        <router-link class="flex hover:bg-rose-300 cursor-pointer px-2 py-1 mx-2 mt-1 border-pink-700/60 border-b-2" :to="{name: 'activity_edit_page', params: {activity_id: value['activity_id']}}" v-for="value in activity_data" tag="button"><button class="flex w-full cursor-pointer justify-between"><span>{{ value['activity_subject'] }}</span><span>{{ value['end_time'] }}</span></button></router-link>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex bg-pink-500 border-pink-700 border-t-4 justify-end py-2">
            <button @click="logout_prompt=true" class="flex py-1 px-4 mx-4 my=2 rounded-full bg-rose-200 hover:bg-rose-700 hover:text-rose-100 text-lg font-bold">Log out</button>
        </div>
    </div>

    <div v-else class="w-screen h-screen flex flex-col bg-pink-300 justify-center items-center">
        <div>Unable to acceess the page due to unauthorized access, please log in to continue</div>
        <router-link class="bg-rose-500 hover:bg-rose-800 font-semibold hover:text-white rounded-full px-6 py-1 m-2" :to="{name: 'login_page'}" tag="button">Login at here</router-link>
    </div>
</template>