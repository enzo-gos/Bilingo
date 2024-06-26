# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/helpers", under: "helpers"
pin "@rails/activestorage", to: "@rails--activestorage.js" # @7.1.3
pin "slick-carousel" # @1.8.1
pin "jquery" # @3.7.1
pin "sortablejs" # @1.15.2
pin "clipboard" # @2.0.11
pin "dropzone" # @6.0.0
pin "just-extend" # @5.1.1
pin "@yaireo/tagify", to: "@yaireo--tagify.js" # @4.26.5
pin "medium-editor" # @5.23.3
pin "process" # @2.0.1
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "lodash.debounce" # @4.0.8
pin "typeit" # @8.8.3
