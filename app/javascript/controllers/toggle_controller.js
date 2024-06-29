import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"];

  toggle(event) {
    event.preventDefault();

    const button = event.currentTarget;

    // Cambiar clases y texto del botón al hacer clic
    button.classList.toggle('btn-primary');
    button.classList.toggle('btn-outline-primary');

    if (button.classList.contains('btn-primary')) {
      button.textContent = 'Disponible';
    } else {
      button.textContent = 'No disponible';
    }

    // Aquí puedes añadir la lógica para enviar datos al servidor si es necesario
    const dayIndex = this.data.get("toggleDay");
    const hour = this.data.get("toggleHour");
    const isChecked = button.classList.contains('btn-primary');
    console.log(`Day: ${dayIndex}, Hour: ${hour}, Checked: ${isChecked}`);
  }
}
