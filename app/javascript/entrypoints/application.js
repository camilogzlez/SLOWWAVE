console.log('Vite ⚡️ Rails');
console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails');

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import $ from "jquery";
import "bootstrap";
import { initHeader } from "../plugins/init_header";
import { initSelect2 } from "../plugins/init_select2";
import { initScrollKeeper } from "../plugins/init_scroll_keeper";
import Turbolinks from "turbolinks";
Turbolinks.start();


// Expose jQuery globally
window.$ = window.jQuery = $;

Rails.start();
ActiveStorage.start();

// Stimulus Setup
import { Application } from "stimulus";
import { registerControllers } from "stimulus-vite-helpers";

const application = Application.start();
const controllers = import.meta.glob("../controllers/*.js", { eager: true });
registerControllers(application, controllers);

// Initialize functions on DOM load
document.addEventListener("DOMContentLoaded", () => {
    initSelect2();
    initHeader();
    initScrollKeeper();
});
