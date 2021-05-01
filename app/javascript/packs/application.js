// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

// 追加
require ('channels/icon_preview.js')
require ('channels/count.js')
require ('channels/count_50.js')
require ('channels/count_100.js')

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

/* jQuery導入について https://qiita.com/whitia/items/34de15b72946f7f3b773 20201230 */ 

import 'bootstrap'
import '../src/application.scss'