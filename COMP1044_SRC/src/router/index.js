import { createRouter, createWebHashHistory } from "vue-router";
import login_page from "../views/login_page.vue";

const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: "/",
            name: "login_page",
            component: login_page
        }
    ]
});

export default router;