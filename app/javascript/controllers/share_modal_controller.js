import { Controller } from '@hotwired/stimulus';
import ClipboardJS from 'clipboard';

// Connects to data-controller="share-modal"
export default class extends Controller {
  static targets = ['modal', 'backdrop', 'shareLink', 'copyBtn'];

  connect() {
    this.toggleClass = 'modal-hidden';
  }

  disconnect() {
    this.close();
  }

  open() {
    $(document.body).addClass('overflow-hidden');
    $(this.backdropTarget).removeClass(this.toggleClass);
    $(this.modalTarget).removeClass(this.toggleClass);
  }

  close() {
    $(document.body).removeClass('overflow-hidden');
    $(this.backdropTarget).addClass(this.toggleClass);
    $(this.modalTarget).addClass(this.toggleClass);
  }

  shareLinkTargetConnected() {
    this.clipboard = new ClipboardJS(this.copyBtnTarget);

    this.clipboard.on('success', () => {
      $(this.copyBtnTarget).addClass('!hidden');
      $(this.shareLinkTarget).find('#copy-success').removeClass('!hidden');

      setTimeout(() => {
        $(this.copyBtnTarget).removeClass('!hidden');
        $(this.shareLinkTarget).find('#copy-success').addClass('!hidden');
      }, 2000);
    });

    this.clipboard.on('error', () => {
      $(this.copyBtnTarget).addClass('!hidden');
      $(this.shareLinkTarget).find('#copy-error').removeClass('!hidden');

      setTimeout(() => {
        $(this.copyBtnTarget).removeClass('!hidden');
        $(this.shareLinkTarget).find('#copy-error').addClass('!hidden');
      }, 2000);
    });
  }

  shareLinkTargetDisconnected() {
    this.clipboard?.destroy();
  }
}
