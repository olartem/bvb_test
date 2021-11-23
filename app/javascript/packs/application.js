import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "bootstrap"
import "../stylesheets/application.scss"
import "jquery"
import "@fortawesome/fontawesome-free/css/all"

global.$ = jQuery;

Rails.start()
Turbolinks.start()
ActiveStorage.start()