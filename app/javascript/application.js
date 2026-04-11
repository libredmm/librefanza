import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"
import ClipboardJS from "clipboard"

// Start Stimulus
const application = Application.start()
application.debug = false
window.Stimulus = application

// Initialize ClipboardJS on all elements with data-clipboard-text
document.addEventListener("turbo:load", () => {
  new ClipboardJS('.btn')
})
