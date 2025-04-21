import { createRouter, createWebHashHistory } from "vue-router";
import login_page from "../views/login_page.vue";
import lead_page from "../views/lead_page.vue";

const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: "/",
            name: "login_page",
            component: login_page
        },

        {
            path: "/lead_page",
            name: "lead_page",
            component: lead_page
        }
    ]
});

export default router;