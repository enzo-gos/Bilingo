import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="request-form"
export default class extends Controller {
  static targets = ['form', 'createBtn', 'closeBtn'];

  connect() {}

  openForm() {
    $(this.createBtnTarget).addClass('!hidden');
  }

  closeForm() {
    $(this.createBtnTarget).removeClass('!hidden');
    $(this.formTarget).empty();
  }
}
