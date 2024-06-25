import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form", "submitButton"]

  open(event) {
    const bookingId = this.element.dataset.calendarEventId
    const bookingData = {
      date: this.element.dataset.calendarEventDate,
      time: this.element.dataset.calendarEventTime,
      psychologistId: this.element.dataset.calendarEventPsychologistId,
      linkToMeet: this.element.dataset.calendarEventLinkToMeet
    }

    this.formTarget.action = `/bookings/${bookingId}`
    this.formTarget.querySelector('[name="booking[date]"]').value = bookingData.date
    this.formTarget.querySelector('[name="booking[time]"]').value = bookingData.time
    this.formTarget.querySelector('[name="booking[psychologist_id]"]').value = bookingData.psychologistId
    this.formTarget.querySelector('[name="booking[link_to_meet]"]').value = bookingData.linkToMeet

    const modal = new bootstrap.Modal(this.modalTarget)
    modal.show()
  }

  submit(event) {
    event.preventDefault()
    const form = this.formTarget
    const submitButton = this.submitButtonTarget

    submitButton.disabled = true

    fetch(form.action, {
      method: form.method,
      body: new FormData(form),
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        window.location.reload()
      } else {
        console.error(data.errors)
        submitButton.disabled = false
      }
    })
    .catch(error => {
      console.error('Error:', error)
      submitButton.disabled = false
    })
  }
}
