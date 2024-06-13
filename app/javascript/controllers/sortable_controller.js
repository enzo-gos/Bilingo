import { Controller } from '@hotwired/stimulus';
import Sortable from 'sortablejs';

// Connects to data-controller="sortable"
export default class extends Controller {
  static targets = ['sortable'];

  connect() {
    this.sortable = Sortable.create(this.element, {
      handle: '.drag-indicator',
      forceFallback: true,
      group: 'sortable-list',
      onEnd: this.end.bind(this),
    });
  }

  end(event) {
    const story_id = event.item.dataset.id;
    const url = this.data.get('url').replace(':id', story_id);

    const data = new FormData();
    data.append('position', event.newIndex + 1);

    fetch(url, {
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
      },
      method: 'PATCH',
      body: data,
    });
  }
}
