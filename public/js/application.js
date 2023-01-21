import { Application, Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"
window.Stimulus = Application.start()

Stimulus.register("read-more", class extends Controller {
  static targets = [ "content" ]

  connect() {
    this.open = false
  }

  toggle(event) {
    event.preventDefault()

    this.open === false ? this.show(event) : this.hide(event)
  }

  show(event) {
    this.open = true

    const target = event.target
    target.innerHTML = 'Read less'
    this.contentTarget.style.setProperty('--read-more-line-clamp', "'unset'")
  }

  hide(event) {
    this.open = false

    const target = event.target
    target.innerHTML = 'Read more'
    this.contentTarget.style.removeProperty('--read-more-line-clamp')
  }
})
