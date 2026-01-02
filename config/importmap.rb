# Pin npm packages by running ./bin/importmap

pin "application"
pin "horizontal_scroller", to: "horizontal_scroller.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"

#
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"