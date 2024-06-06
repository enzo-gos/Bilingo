import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ['successToast', 'errorToast'];

  successToastTargetConnected() {
    this.successTimeout = setTimeout(() => {
      $(this.successToastTarget).remove();
    }, 2500);
  }

  successToastTargetDisconnected() {
    clearTimeout(this.successTimeout);
  }

  errorToastConnected() {
    this.errorTimeout = setTimeout(() => {
      $(this.errorToastTarget).remove();
    }, 2500);
  }

  errorToastDisconnected() {
    clearTimeout(this.errorTimeout);
  }
}
