import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="rephraser"
export default class extends Controller {
  connect() {}

  rephrase(event) {
    const data_id = $(event.target).closest('.action-btn').attr('data-id');
    const added_load = $(event.target).parents('.translate-text').find('.translate-content');

    if (added_load.find('.loader-sm').length === 0) {
      const newDiv = $('<div></div>').addClass('loader-sm !ml-3').attr('id', `rephrase_${data_id}`);
      added_load.append(newDiv);
    }
  }
}
