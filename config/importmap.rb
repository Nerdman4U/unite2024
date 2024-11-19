# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

#pin_all_from "app/javascript/controllers", under: "controllers"

# An effort to work with underscore/backbone =>
#pin_all_from "app/javascript/collections", under: "collections"
#pin_all_from "app/javascript/views", under: "views"
#pin_all_from "app/javascript/routers", under: "routers"
#pin_all_from "app/javascript/models", under: "models"

pin "react" # @18.3.1
pin "react-dom" # @18.3.1
pin "scheduler" # @0.23.2
pin_all_from "app/javascript/components", under: "components"
