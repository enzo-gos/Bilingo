import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['dropdownBtn', 'dropdownList'];

  connect() {
    this.dropdownBtnTargets.forEach((btn, index) => {
      $(btn).on('click', () => {
        const dropdownList = this.dropdownListTargets[index];

        $(btn).toggleClass('open');

        $(btn).find('.dropdown-icon').toggleClass('open');
        $(dropdownList).toggleClass('open');
      });
    });
  }
}
