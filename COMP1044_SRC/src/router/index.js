import { createRouter, createWebHashHistory } from "vue-router";
import login_page from "../views/login_page.vue";
import lead_page from "../views/lead_page.vue";
import lead_edit_page from "../views/lead_edit_page.vue";
import user_page from "../views/user_page.vue";
import user_edit_page from "../views/user_edit_page.vue";
import lead_creation_page from "../views/lead_creation_page.vue";

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
        },

        {
            path: "/lead_edit_page/:individual_id",
            name: "lead_edit_page",
            component: lead_edit_page,
            props: true
        },

        {
            path: "/user_page",
            name: "user_page",
            component: user_page
        },

        {
            path: "/user_edit_page/:user_id",
            name: "user_edit_page",
            component: user_edit_page,
            props: true
        },

        {
            path: "/lead_creation_page",
            name: "lead_creation_page",
            component: lead_creation_page
        }
    ]
});

export default router;