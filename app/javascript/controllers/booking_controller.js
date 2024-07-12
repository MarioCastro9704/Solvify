import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form", "patientForm", "daySelect", "timeSelect", "reasonSelect", "submitButton" ]
  static values = { psychologistId: Number }

  connect() {
    console.log("Booking controller connected")
  }

  togglePatientForm(event) {
    if (event.target.value === 'other') {
      this.patientFormTarget.style.display = 'block'
    } else {
      this.patientFormTarget.style.display = 'none'
    }
    this.validateForm()
  }

  dayChanged() {
    const selectedDate = this.daySelectTarget.value
    this.fetchAvailabilities(selectedDate)
  }

  fetchAvailabilities(date) {
    fetch(`/availabilities?date=${date}&psychologist_id=${this.psychologistIdValue}`)
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
        this.timeSelectTarget.innerHTML = '<option value="">No times available</option>'
      })
  }

  updateTimeSelect(times) {
    this.timeSelectTarget.innerHTML = '<option value="">Select a time</option>'
    times.forEach(time => {
      const option = document.createElement('option')
      option.value = time
      option.textContent = time
      this.timeSelectTarget.appendChild(option)
    })
    this.validateForm()
  }

  validateForm() {
    const forWhomInputs = this.element.querySelectorAll('input[name="for_whom"]')
    const forWhom = Array.from(forWhomInputs).find(input => input.checked)?.value

    const patientInfoComplete = forWhom === 'me' || (forWhom === 'other' && this.arePatientFieldsFilled())
    const daySelected = this.daySelectTarget.value !== ""
    const timeSelected = this.timeSelectTarget.value !== ""
    const reasonSelected = this.reasonSelectTarget.value !== ""

    this.submitButtonTarget.disabled = !(patientInfoComplete && daySelected && timeSelected && reasonSelected)
  }

  arePatientFieldsFilled() {
    const requiredFields = this.patientFormTarget.querySelectorAll('input[type="text"], input[type="email"], input[type="tel"]')
    return Array.from(requiredFields).every(field => field.value.trim() !== '')
  }
}
