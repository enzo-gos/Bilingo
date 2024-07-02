import { Controller } from '@hotwired/stimulus';
import TypeIt from 'typeit';

// Connects to data-controller="summary"
export default class extends Controller {
  static targets = ['translated', 'loader'];
  connect() {}

  translatedTargetConnected() {
    $('#translated-summary-type').empty();

    const html = $(this.translatedTarget).html();
    $(this.loaderTarget).addClass('!hidden');

    this.typeit = new TypeIt('#translated-summary-type', {
      speed: 20,
      strings: html,
    }).go();
  }

  summarize() {
    this.typeit.freeze();
    this.typeit.destroy();

    $(this.translatedTarget).text('');
    $(this.loaderTarget).removeClass('!hidden');
  }
}
