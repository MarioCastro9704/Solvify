import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["calendar"]
  static values = {
    currentView: String,
    currentDate: String
  }

  navigate(event) {
    const direction = event.currentTarget.dataset.direction
    const currentDate = new Date(this.currentDateValue)
    let newDate

    if (this.currentViewValue === 'week') {
      newDate = new Date(currentDate.setDate(currentDate.getDate() + (direction === 'next' ? 7 : -7)))
    } else {
      newDate = new Date(currentDate.setMonth(currentDate.getMonth() + (direction === 'next' ? 1 : -1)))
    }

    this.fetchNewCalendar(newDate)
  }

  fetchNewCalendar(date) {
    const url = new URL(window.location.href)
    url.searchParams.set('date', date.toISOString().split('T')[0])
    url.searchParams.set('view', this.currentViewValue)

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
      this.currentDateValue = date.toISOString().split('T')[0]
      this.updateHeader(date)
    })
  }

  updateHeader(date) {
    const header = this.element.querySelector('h2')
    header.textContent = date.toLocaleString('default', { month: 'long', year: 'numeric' })
  }
}
