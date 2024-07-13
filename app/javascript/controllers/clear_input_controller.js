import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  clear() {
    this.contentTarget.value = "";
  }
}
