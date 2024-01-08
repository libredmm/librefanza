# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "bootstrap" # @5.3.2
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin_all_from "app/javascript/controllers", under: "controllers", to: "controllers"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
