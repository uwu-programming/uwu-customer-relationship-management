import { createRouter, createWebHashHistory } from "vue-router";
import login_page from "../views/login_page.vue";
import lead_page from "../views/lead_page.vue";
import lead_edit_page from "../views/lead_edit_page.vue";
import user_page from "../views/user_page.vue";
import user_edit_page from "../views/user_edit_page.vue";
import individual_creation_page from "../views/individual_creation_page.vue";
import contact_page from "../views/contact_page.vue";
import contact_edit_page from "../views/contact_edit_page.vue";
import activity_creation_page from "../views/activity_creation_page.vue";
import activity_edit_page from "../views/activity_edit_page.vue";
import contact_view_page from "../views/contact_view_page.vue";
import customer_page from "../views/customer_page.vue";
import customer_edit_page from "../views/customer_edit_page.vue";
import customer_view_page from "../views/customer_view_page.vue";

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
            path: "/individual_creation_page",
            name: "individual_creation_page",
            component: individual_creation_page
        },

        {
            path: "/contact_page",
            name: "contact_page",
            component: contact_page
        },

        {
            path: "/contact_edit_page/:individual_id",
            name: "contact_edit_page",
            component: contact_edit_page,
            props: true
        },

        {
            path: "/activity_creation_page",
            name: "activity_creation_page",
            component: activity_creation_page
        },

        {
            path: "/activity_edit_page/:activity_id",
            name: "activity_edit_page",
            component: activity_edit_page,
            props: true
        },

        {
            path: "/contact_view_page/:individual_id",
            name: "contact_view_page",
            component: contact_view_page,
            props: true
        },

        {
            path: "/customer_page",
            name: "customer_page",
            component: customer_page
        },

        {
            path: "/customer_edit_page/:individual_id",
            name: "customer_edit_page",
            component: customer_edit_page,
            props: true
        },

        {
            path: "/customer_view_page/:individual_id",
            name: "customer_view_page",
            component: customer_view_page,
            props: true
        },
    ]
});

export default router;