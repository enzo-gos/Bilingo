import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="notification-popup"
export default class extends Controller {
  static targets = ['popup'];

  connect() {}

  popupTargetConnected() {
    $(this.element).addClass('!left-5');

    this.popUpTimeout = setTimeout(() => {
      $(this.element).removeClass('!left-5');
    }, 5000);
  }

  popupTargetDisconnected() {
    clearTimeout(this.popUpTimeout);
  }
}
