import { Controller } from '@hotwired/stimulus';
import TypeIt from 'typeit';

// Connects to data-controller="summary"
export default class extends Controller {
  static targets = ['translated', 'loader'];
  connect() {}

  translatedTargetConnected() {
    const html = $(this.translatedTarget).html();
    $(this.loaderTarget).addClass('!hidden');

    new TypeIt('#translated-summary-type', {
      speed: 20,
      strings: html,
    }).go();
  }

  summarize() {
    const html = $(this.translatedTarget).html();
    $(this.loaderTarget).removeClass('!hidden');
  }
}
