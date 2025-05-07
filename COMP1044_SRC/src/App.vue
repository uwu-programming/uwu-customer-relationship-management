<script setup>
    import {ref} from 'vue';
    import axios from 'axios';

    import { RouterView } from 'vue-router';

    const current_crm_user_role = ref("");

    // get current crm user role
    const get_current_crm_user_role = async () => {
        try {
            const get_current_crm_user_role_response = await axios.post("../backend/get_current_user_api.php");
            current_crm_user_role['value'] = get_current_crm_user_role_response['data']['user_id'];
        } catch(error) {
            alert(error);
        }
    }

    // record the current page
    const page_status = {
        lead: ref("lead"),
        contact: ref("contact"),
        customer: ref("customer"),
        company: ref("company"),
        activity: ref("activity"),
        user: ref("user"),
        my_page: ref("my_page")
    }

    const current_page = ref("");

    get_current_crm_user_role();
</script>

<template>
    <RouterView/>
    <div class="flex flex-row justify-between items-center sticky bottom-0 bg-pink-600 border-pink-900 border-t-4 py-1">
        <div class="flex flex-row">
            <router-link v-model="page_status.lead" @click="current_page = 'lead'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-rose-300': current_page == page_status.lead}]" :to="{name: 'lead_page'}" tag="button">Lead page</router-link>
            <router-link v-model="page_status.contact" @click="current_page = 'contact'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-pink-300': current_page == page_status.contact}]" :to="{name: 'contact_page'}" tag="button">Contact page</router-link>
            <router-link v-model="page_status.customer" @click="current_page = 'customer'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-pink-300': current_page == page_status.customer}]" :to="{name: 'customer_page'}" tag="button">Customer page</router-link>
            <router-link v-model="page_status.company" @click="current_page = 'company'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-pink-300': current_page == page_status.company}]" :to="{name: 'company_page'}" tag="button">Company page</router-link>
            <router-link v-model="page_status.activity" @click="current_page = 'activity'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-pink-300': current_page == page_status.activity}]" :to="{name: 'activity_page'}" tag="button">Activity page</router-link>
            <router-link v-model="page_status.user" @click="current_page = 'user'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-pink-300': current_page == page_status.user}]" v-if="current_crm_user_role <= 2" :to="{name: 'user_page'}" tag="button"><button>User page</button></router-link>
            <div v-else></div>
        </div>
        <div>
            <router-link v-model="page_status.my_page" @click="current_page = 'my_page'" :class="['my-2 mx-4 flex justify-center items-center px-6 rounded-full text-lg font-bold bg-rose-100 hover:bg-rose-300 hover:text-gray-900', {'bg-rose-300': current_page == page_status.my_page}]" :to="{name: 'my_page'}" tag="button">My profile</router-link>
        </div>
    </div>
</template>