import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="auth-modal"
export default class extends Controller {
  static targets = ['modal', 'backdrop'];

  connect() {
    this.toggleClass = 'modal-hidden';
  }

  disconnect() {
    this.close();
  }

  open() {
    $(document.body).addClass('overflow-hidden');
    $(this.backdropTarget).removeClass(this.toggleClass);
    $(this.modalTarget).removeClass(this.toggleClass);
  }

  close(event) {
    $(document.body).removeClass('overflow-hidden');
    $(this.backdropTarget).addClass(this.toggleClass);
    $(this.modalTarget).addClass(this.toggleClass);
  }
}
