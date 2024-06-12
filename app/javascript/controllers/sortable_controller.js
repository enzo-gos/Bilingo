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
    });
  }
}
