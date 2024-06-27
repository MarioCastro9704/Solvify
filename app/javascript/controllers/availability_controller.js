import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const checkbox = event.target
    checkbox.classList.toggle('active')
  }
}
