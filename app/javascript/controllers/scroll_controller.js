// app/javascript/controllers/scroll_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["messages"];

  connect() {
    this.scrollToBottom();
    this.messagesTarget.addEventListener("DOMNodeInserted", this.scrollToBottom.bind(this));
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight - this.messagesTarget.clientHeight;
  }
}
