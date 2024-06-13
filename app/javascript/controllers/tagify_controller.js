import { Controller } from '@hotwired/stimulus';
import Tagify from '@yaireo/tagify';

// Connects to data-controller="tagify"
export default class extends Controller {
  static targets = ['tagInput'];
  async connect() {
    if ($('html').attr('data-turbo-preview') !== undefined) return;
    const tags = await (await fetch(this.data.get('url'))).json();

    const _ = new Tagify(this.tagInputTarget, {
      whitelist: tags,
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
