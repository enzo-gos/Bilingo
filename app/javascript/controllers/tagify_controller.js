import { Controller } from '@hotwired/stimulus';
import Tagify from '@yaireo/tagify';

// Connects to data-controller="tagify"
export default class extends Controller {
  static targets = ['tagInput'];
  connect() {
    if ($('html').attr('data-turbo-preview') !== undefined) return;

    const _ = new Tagify(this.tagInputTarget, {
      whitelist: ['foo', 'bar', 'baz'],
      focusable: false,
      delimiters: ',| ',
      trim: true,
      dropdown: {
        position: 'input',
        enabled: 1,
        fuzzySearch: true,
      },
    });
  }
}
