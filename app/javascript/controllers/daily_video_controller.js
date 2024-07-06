import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="daily-video"
export default class extends Controller {
  static targets = ['daily']
  static values = {
    videocall: String
  }

  connect() {
  }

  endCall() {
    if (this.call) {
      this.call.leave();
      this.call.destroy();
      this.call = null;
    }
  }

  joinCall() {
    const url = `https://api.daily.co/v1/rooms/${this.videocallValue}`;
    console.log(this.videocallValue);
    const token = 'afd0d96efeb72db1d03e5c1618aaa78a35e2ecac1cd249b411ce2196ceddae26'; // Reemplaza con tu token

    fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      }
    })
      .then(response => response.json())
      .then(data => {
        console.log('Success:', data);
        const callUrl = data.url;

        this.call = window.Daily.createFrame({
          iframeStyle: {
            position: 'fixed',
            border: '1px solid black',
            mode: 'grid',
            width: '100%',
            height: '450px',
            right: '0px',
            top: '250px',
          },
        });

        this.call.join({ url: callUrl });
      })
      .catch(error => {
        console.error('Error:', error);
      });
  }
}
