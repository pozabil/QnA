// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "jquery"
import "utilities/answer_editing"
import "utilities/question_editing"
import "@nathanvda/cocoon"
// import * as _ from "underscore"
// import * as Gh3 from "gh3"
import "utilities/gist_preview_loader"
import "utilities/voteable_rating_manager"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
