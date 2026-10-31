import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"
import ClipboardJS from "clipboard"

const application = Application.start()
application.debug = false
window.Stimulus = application

let clipboard

const showImageFallback = (image) => {
  image.closest("[data-image-frame]")?.classList.add("image-missing")
}

document.addEventListener("error", (event) => {
  if (event.target instanceof HTMLImageElement) showImageFallback(event.target)
}, true)

document.addEventListener("turbo:load", () => {
  clipboard?.destroy()
  clipboard = new ClipboardJS("[data-clipboard-text]")
  clipboard.on("success", (event) => {
    event.clearSelection()
    const label = event.trigger.querySelector("[data-copy-label]")
    if (label) {
      const original = label.dataset.originalLabel ||= label.textContent
      label.textContent = "Copied!"
      window.setTimeout(() => { label.textContent = original }, 2000)
    }
    const status = document.querySelector(".copy-status")
    if (status) status.textContent = "Copied to clipboard."
  })
  clipboard.on("error", () => {
    const status = document.querySelector(".copy-status")
    if (status) status.textContent = "Could not copy automatically. Select the text to copy it."
  })
  document.querySelectorAll("[data-image-frame] img").forEach((image) => {
    if (image.complete && image.naturalWidth === 0) showImageFallback(image)
  })
})

document.addEventListener("turbo:before-cache", () => {
  clipboard?.destroy()
  document.querySelectorAll("[data-copy-label]").forEach((label) => {
    if (label.dataset.originalLabel) label.textContent = label.dataset.originalLabel
  })
  const status = document.querySelector(".copy-status")
  if (status) status.textContent = ""
})
