import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="writer-navigation"
export default class extends Controller {
  static targets = ['content', 'chapters', 'contentBtn', 'chaptersBtn'];

  connect() {}

  showContent() {
    $(this.chaptersTarget).addClass('hidden');
    $(this.chaptersBtnTarget).removeClass('active');

    $(this.contentTarget).removeClass('hidden');
    $(this.contentBtnTarget).addClass('active');
  }

  showChapters() {
    $(this.contentTarget).addClass('hidden');
    $(this.contentBtnTarget).removeClass('active');

    $(this.chaptersTarget).removeClass('hidden');
    $(this.chaptersBtnTarget).addClass('active');
  }
}
