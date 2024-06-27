document.addEventListener('turbolinks:load', function() {
  const visibilityToggle = document.getElementById('serviceVisibilityToggle');
  const visibilityStatus = document.getElementById('visibilityStatus');

  if (visibilityToggle && visibilityStatus) {
    visibilityToggle.addEventListener('change', function() {
      if (this.checked) {
        visibilityStatus.textContent = 'Visible';
        visibilityStatus.classList.remove('bg-secondary');
        visibilityStatus.classList.add('bg-success');
      } else {
        visibilityStatus.textContent = 'Oculto';
        visibilityStatus.classList.remove('bg-success');
        visibilityStatus.classList.add('bg-secondary');
      }
    });
  }
});
