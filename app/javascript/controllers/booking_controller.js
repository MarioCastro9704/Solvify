import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form", "daySelect", "timeSelect", "reasonSelect", "submitButton" ]
  static values = { psychologistId: Number }

  connect() {
    console.log("Booking controller connected")
    this.validateForm()
  }

  dayChanged() {
    const selectedDate = this.daySelectTarget.value
    this.fetchAvailabilities(selectedDate)
  }

  fetchAvailabilities(date) {
    fetch(`/availabilities/for_date?date=${date}&psychologist_id=${this.psychologistIdValue}`)
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok')
        }
        return response.json()
      })
      .then(data => {
        this.updateTimeSelect(data)
      })
      .catch(error => {
        console.error('There was a problem with the fetch operation:', error)
        this.timeSelectTarget.innerHTML = '<option value="">No hay horarios disponibles</option>'
      })
  }

  updateTimeSelect(times) {
    this.timeSelectTarget.innerHTML = '<option value="">Selecciona una hora</option>'
    times.forEach(time => {
      const option = document.createElement('option')
      option.value = time
      option.textContent = time
      this.timeSelectTarget.appendChild(option)
    })
    this.validateForm()
  }

  validateForm() {
    const dateSelected = this.daySelectTarget.value !== ""
    const timeSelected = this.timeSelectTarget.value !== ""
    const reasonSelected = this.reasonSelectTarget.value !== ""

    this.submitButtonTarget.disabled = !(dateSelected && timeSelected && reasonSelected)
  }
}
