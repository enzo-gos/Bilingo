import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="story-view"
export default class extends Controller {
  static targets = ['description', 'moreBtn', 'lessBtn'];

  connect() {}

  details() {
    $(this.descriptionTarget).removeClass('story-description-minimize');
  }

  minimize() {
    $(this.descriptionTarget).addClass('story-description-minimize');
  }
}
