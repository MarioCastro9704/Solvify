import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["currentTimeLine"]

  connect() {
    this.updateCurrentTimeLine()
    this.interval = setInterval(() => {
      this.updateCurrentTimeLine()
    }, 60000) // Update every minute
  }

  disconnect() {
    clearInterval(this.interval)
  }

  updateCurrentTimeLine() {
    const currentTime = new Date()
    const currentHour = currentTime.getHours()
    const currentMinute = currentTime.getMinutes()
    const minutesSinceMidnight = currentHour * 60 + currentMinute
    this.currentTimeLineTarget.style.top = `${minutesSinceMidnight}px`
  }
}
