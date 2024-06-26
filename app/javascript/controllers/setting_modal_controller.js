import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="setting-modal"
export default class extends Controller {
  static targets = ['modal', 'form', 'fontsize', 'pspace', 'translation'];

  connect() {
    this.toggleClass = 'modal-hidden';

    $(this.formTarget).on('submit', (event) => {
      event.preventDefault();
    });

    $(this.fontsizeTarget).val($(':root').css('--chapter-font-size').replace('px', ''));
    $(this.pspaceTarget).val($(':root').css('--chapter-p-height').replace('px', ''));
    $(this.translationTarget).val($(':root').css('--chapter-translation'));

    $(this.formTarget).on('change', (event) => {
      const font_size = event.currentTarget['fontsize'].value;
      const p_space = event.currentTarget['p_spacing'].value;
      const show_translate = event.currentTarget['show_translate'].value;

      $(':root').css({
        '--chapter-font-size': `${font_size}px`,
        '--chapter-p-height': `${p_space}px`,
        '--chapter-translation': show_translate,
      });
    });
  }

  disconnect() {
    this.close();
  }

  open() {
    $(this.backdropTarget).removeClass(this.toggleClass);
    $(this.modalTarget).removeClass(this.toggleClass);
  }

  close() {
    $(this.backdropTarget).addClass(this.toggleClass);
    $(this.modalTarget).addClass(this.toggleClass);
  }
}
