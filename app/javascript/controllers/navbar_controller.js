import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['mobileMenu', 'mobileSidebar'];
  connect() {
    $(this.mobileMenuTarget).on('click', (e) => {
      $(this.mobileSidebarTarget).toggleClass('open');
      $(document.body).toggleClass('overflow-hidden');
    });
  }
}
