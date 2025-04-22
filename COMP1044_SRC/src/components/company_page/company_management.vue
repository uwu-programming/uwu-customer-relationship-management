<script setup>
import axios from 'axios';
import {ref, onMounted} from 'vue';

const companies = ref([]);
const selectedCompany = ref(null);
const showModal = ref(false);
const modalMode = ref('create'); 
const formData = ref({
    company_id: null,
    company_name: '',
    company_address: ''
});

const retrieve_company = async () => {
    try{
        const response = await axios.get('/CRM/COMP1044_SRC/backend/retrieve_company_api.php');
        companies.value = response.data;
    }catch(error){
        alert(error);
    }
};

const open_modal = (mode,company=null) =>{
    modalMode.value = mode;
    if(company){
        formData.value = { ...company };
    }else{
        formData.value = {
            company_id: null,
            company_name: '',
            company_address: ''
        };
    }
    showModal.value = true;
};

const close_modal=()=>{
    showModal.value = false;
    formData.value = {
        company_id: null,
        company_name: '',
        company_address: ''
    };
};

const save_company = async () => {

    try {
        if (modalMode.value === 'create') {
            await axios.post('/CRM/COMP1044_SRC/backend/retrieve_company_api.php', formData.value);
        } else {
            await axios.put('/CRM/COMP1044_SRC/backend/retrieve_company_api.php', formData.value);
        }
        await retrieve_company();
        close_modal();
        
    } catch (error) {
        alert(error);
    }
};

const delete_company = async (company) => {

    if (!confirm('Are you sure you want to delete this company?')) return;
    try {
        await axios.delete('/CRM/COMP1044_SRC/backend/retrieve_company_api.php', {
            data: { company_id: company.company_id }
        });
        await retrieve_company();
    }catch (error){
        alert(error);
    }
};

const view_company = async (company) => {
    try {
        const response = await axios.get(`/CRM/COMP1044_SRC/backend/retrieve_company_api.php?id=${company.company_id}`);
        selectedCompany.value = response.data;
    } catch (error) {
        alert(error);
    }
};

const link_indiv_company = async (individualId, companyId) => {

    try {
        await axios.post('/CRM/COMP1044_SRC/backend/link_indiv_company_api.php', {
            individual_id: individualId,
            company_id: companyId
        });
        //update details after every succesful linking
        if (selectedCompany.value) {
            await view_company(selectedCompany.value.company);
        }

    } catch (error) {
        alert(error);
    }
};

const unlink_indiv_company = async (individualId) => {
    try {
        await axios.delete('/CRM/COMP1044_SRC/backend/link_indiv_company_api.php', {
            data: { individual_id: individualId }
        });
        if (selectedCompany.value) {
            await view_company(selectedCompany.value.company);
        }
    } catch (error) {
        alert(error);
    }
};

onMounted(() => {
    retrieve_company();
});


</script>
<template>
    <div class="p-4" style="background-color: #ffb6c1; min-height: 100vh;">
        <div class="mb-4">
            <h1 class="text-2xl font-bold">Company Management System</h1>
            <button @click="open_modal('create')" class="bg-blue-500 text-white px-4 py-2 rounded">
            Add New Company
            </button>
        </div>

       

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div v-for="company in companies" :key="company.company_id" class="border p-4 bg-white rounded">
                <h2 class="text-xl font-semibold">{{ company.company_name }}</h2>
                <p class="text-gray-600">{{ company.company_address }}</p>
                <div class="mt-2">
                  <button @click="view_company(company)" class="bg-green-500 text-white px-2 py-1 rounded mr-2">View</button>
                    <button @click="open_modal('edit', company)" class="bg-yellow-500 text-white px-2 py-1 rounded mr-2">Edit</button>
                    <button @click="delete_company(company)" class="bg-red-500 text-white px-2 py-1 rounded">Delete</button>
                </div>
            </div>
        </div>

    
        <!-- modal for displaying each existing company details-->
        <div v-if="selectedCompany" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
            <div class="bg-white p-4 w-full max-w-md rounded">
                <h2 class="text-xl font-bold">{{ selectedCompany.company.company_name }}</h2>
                <p class="text-gray-600">{{ selectedCompany.company.company_address }}</p>
                <div class="mt-4">
                    <h3 class="font-bold">Associated Individuals</h3>
                    <div v-if="selectedCompany.individuals.length === 0" class="text-gray-500">
                    No individuals associated with this company.
                    </div>
                    <div v-else>
                        <div v-for="individual in selectedCompany.individuals" :key="individual.individual_id" class="border p-2 mt-2">
                            <p>{{ individual.honorifics }} {{ individual.last_name }}</p>
                            <p class="text-sm text-gray-600">{{ individual.relationship }}</p>
                        </div>
                    </div>
                </div>
                <button @click="selectedCompany = null" class="mt-4 bg-gray-500 text-white px-4 py-2 rounded">Close</button>
            </div>
        </div>

        
        <!-- modal for creating and/or editing a company-->
        <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
            <div class="bg-white p-4 w-full max-w-md rounded">
                <h2 class="text-xl font-bold">{{ modalMode === 'create' ? 'Add New Company' : 'Edit Company' }}</h2>
            <form @submit.prevent="save_company" class="mt-4">
                    <div class="mb-4">
                        <label class="block">Company Name</label>
                        <input v-model="formData.company_name" type="text" required class="w-full border p-2">
                    </div>
                    <div class="mb-4">
                        <label class="block">Company Address</label>
                        <textarea v-model="formData.company_address" required class="w-full border p-2"></textarea>
                    </div>
                <div class="flex justify-end">
                        <button type="button" @click="close_modal" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancel</button>
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">
                        {{modalMode === 'create' ? 'Create' : 'Save'}}
                    </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template> 