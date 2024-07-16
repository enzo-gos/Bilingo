import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = [];
  connect() {}

  mark_as_read(event) {
    const url = this.data
      .get('url')
      .replace(':id', $(event.target).closest('.notification-item').attr('data-notification-id'));

    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        Accept: 'application/json',
      },
      credentials: 'same-origin',
    });
  }
}
