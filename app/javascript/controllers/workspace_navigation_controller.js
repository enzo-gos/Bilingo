import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="workspace-navigation"
export default class extends Controller {
  static targets = ['publishedBtn', 'allBtn'];
  connect() {}

  published() {
    $(this.publishedBtnTarget).addClass('active');
    $(this.allBtnTarget).removeClass('active');
  }

  all() {
    $(this.publishedBtnTarget).removeClass('active');
    $(this.allBtnTarget).addClass('active');
  }
}
