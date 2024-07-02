import { Controller } from '@hotwired/stimulus';
import autosize from 'autosize';

// Connects to data-controller="comment"
export default class extends Controller {
  static targets = ['commentList', 'chapter', 'commentInput', 'commentBody', 'commentGroup', 'commentParagraph'];
  connect() {
    this.highlights = [];
  }

  commentInputTargetConnected() {
    autosize($(this.commentInputTarget));
  }

  commentGroupTargetConnected() {
    this.commentParagraphTargets.forEach((p) => {
      const pId = $(p).attr('data-p-id');
      $(p).text($(`[data-p-id="${pId}"]`).html());
    });
  }

  commenting(event) {
    $(this.commentInputTarget).val($(event.target).html());
  }

  reply() {
    $(this.commentInputTarget).click();
  }

  open() {
    $(this.commentBodyTarget).empty();
    const wrapper = $('<div>', { class: 'my-12' });
    const loader = $('<div>', { class: 'loader' });
    wrapper.append(loader);
    $(this.commentBodyTarget).append(wrapper);

    $(this.commentListTarget).removeClass('-right-full');
    $(this.commentListTarget).addClass('right-0');
    $(this.chapterTarget).addClass('comment-active');

    this.unhighlight();
  }

  close() {
    $(this.commentListTarget).removeClass('right-0');
    $(this.commentListTarget).addClass('-right-full');
    $(this.chapterTarget).removeClass('comment-active');

    this.unhighlight();
  }

  highlight(event) {
    this.unhighlight();

    const pId = $(event.target).closest('.comment-btn').attr('data-id');
    this.highlights = [...this.highlights, pId];

    const highlightElement = $(`.chapter-content [data-p-id="${pId}"]`);
    $('html, body').animate({ scrollTop: highlightElement.offset().top - 70 }, 'slow');
    highlightElement.css('background-color', 'yellow');
  }

  unhighlight() {
    this.highlights.forEach((el) => {
      $(`.chapter-content [data-p-id="${el}"]`).css('background-color', '');
    });
    this.highlights = [];
  }
}
