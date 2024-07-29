import { Controller } from '@hotwired/stimulus';
import autosize from 'autosize';

// Connects to data-controller="comment"
export default class extends Controller {
  static targets = ['commentList', 'chapter', 'commentInput', 'commentBody', 'commentGroupItem', 'commentItem'];
  connect() {
    this.highlights = [];
  }

  commentInputTargetConnected() {
    autosize($(this.commentInputTarget));
  }

  commentItemTargetConnected(event) {
    const currentUserId = $('[data-comment-user-id]').attr('data-comment-user-id');
    const commenterId = $(event).attr('data-commenter-id');

    if (
      commenterId == currentUserId ||
      $('#user-comment-role').text().split(',').includes('admin') ||
      $('#user-comment-author').text() === 'true'
    ) {
      $(event).find('.delete-btn').removeClass('hidden');
    }

    if (currentUserId && commenterId != currentUserId) {
      $(event).find('.reply-btn').removeClass('hidden');
    }
  }

  commentGroupItemTargetConnected(event) {
    const pId = $(event).attr('data-id');
    $(event)
      .find(`.comment-paragraph[data-p-id="${pId}"]`)
      .text($(`[data-p-id="${pId}"]`).html());
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
