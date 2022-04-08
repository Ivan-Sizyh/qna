// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require activestorage
require("@rails/actioncable")
require("@nathanvda/cocoon")
//= require action_cable
//= require_tree .

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "utilities/answers"
import "utilities/inline_question_form"
import "utilities/votes"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const App = App || {};
App.cable = ActionCable.createConsumer();
