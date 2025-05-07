<script setup>
    import axios from "axios";
    import {ref} from "vue";

    const user_id = ref();
    const password = ref();

    const invalid = ref(false);
    const success_prompt = ref(false);

    const login = async () => {
        try {
            const response = await axios.post("../backend/login_api.php", {user_id: user_id.value, password: password.value});
            if (response.status == 204){
                invalid.value = false;
                success_prompt.value = true;
            } else {
                invalid.value = true;
            }
        } catch (error){
            alert(error);
        }
    };
</script>

<template>
    <div v-if="success_prompt" class="fixed z-8 w-full h-full flex justify-center items-center bg-gray-800/70">
        <div class="z-8 fixed w-120 h-40 bg-rose-400 flex flex-col justify-center items-center m-4 p-2 border-pink-700 border-3 rounded-md">
            <div class="m-4 font-bold text-lg">Successfully logged in</div>
            <div class="flex flex-row mx-4 mt-4 font-semibold text-2xl text-white">
                <router-link :to="{name: 'my_page'}" tag="button"><button class="w-28 mx-4 px-6 py-1 bg-green-600 rounded-full hover:text-fuchsia-50 hover:bg-green-800">Ok</button></router-link>
            </div>
        </div>
    </div>

    <div class="flex flex-col h-80 w-150 bg-pink-400 items-center rounded-lg border-pink-700 border-3">
        <div class="flex flex-col w-full h-full justify-between items-center">
            <span class="mt-3 text-center font-bold decoration-2 text-xl">Welcome back</span>

            <div class="flex flex-col py-2 px-2">
                <div class="flex flex-col w-100 my-2">
                    <label for="user_id_input" class="bg-pink-500 font-semibold mb-2 px-4 rounded-md border-pink-700 border-2 flex w-max">User ID:</label>
                    <input v-model="user_id" class="bg-white rounded-md border-2 border-pink-700 h-8 px-2 py-1" type="text" name="user_id_input" id="user_id_input"/>
                </div>

                <div class="flex flex-col w-100 my-2">
                    <label for="password_input" class="bg-pink-500 font-semibold mb-2 px-4 rounded-md border-pink-700 border-2 flex w-max">Password:</label>
                    <input v-model="password" class="bg-white rounded-md border-2 border-pink-700 h-8 px-2 py-1" type="password" name="password_input" id="password_input"/>
                </div>
            </div>

            <div v-if="invalid" class="px-4 text-red-700">The entered user ID and password does not match the record available in database, pwease try again.</div>

            <button @click="login" class="mb-3 font-bold py-1 px-4 rounded-full bg-rose-200 hover:bg-rose-800 hover:text-white">Login</button>
        </div>
    </div>
</template>