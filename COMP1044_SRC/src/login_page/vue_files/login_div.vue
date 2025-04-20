<script setup>

</script>

<template>
    <div class="flex flex-col h-80 w-150 bg-rose-500 items-center">
        <div class="flex flex-col">
            <span class="my-10 text-center">Welcome back</span>

            <div class="flex flex-col">
                <label for="user_id_input" class="">User id:</label>
                <input class="bg-white" type="text" name="user_id_input" id="user_id_input"/>
            </div>

            <div class="flex flex-col">
                <label for="password_input">Password:</label>
                <input class="bg-white" type="password" name="password_input" id="password_input"/>
            </div>

            <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full">Login</button>
        </div>
    </div>
</template>