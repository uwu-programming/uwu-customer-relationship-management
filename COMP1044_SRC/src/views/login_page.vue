<script setup>
    import login_div from '../components/login_page/login_div.vue';
    import decoration_div from '../components/login_page/decoration_div.vue';
</script>

<template>
    <div class="flex w-screen h-screen bg-cyan-500">
        <div class="flex flex-col w-550 justify-center items-center">
            <h1 class="text-center mb-20">UwU ABB<br>Customer Relationship Management System</h1>
            <login_div></login_div>
        </div>
        <decoration_div></decoration_div>
    </div>
</template>