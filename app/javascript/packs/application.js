// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

// Foundation setup.
import 'foundation-sites'
Foundation.addToJquery($)
$(document).on('turbolinks:load', function() {
  $(document).foundation()
});
require("foundation-sites/dist/css/foundation")

// Custom JavaScripts.
import 'packs/direct_uploads.js'
import 'packs/songs.coffee'
import 'packs/tracks.coffee'

// Custom Stylesheets.
import 'src/application'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
