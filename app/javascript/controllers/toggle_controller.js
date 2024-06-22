// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menuIcon", "closeIcon"]

  connect() {
  }

  toggle() {
    this.menuIconTarget.classList.toggle('d-none')
    this.closeIconTarget.classList.toggle('d-none')
  }
}
