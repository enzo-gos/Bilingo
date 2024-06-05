import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = [];

  connect() {
    document.addEventListener('turbo:load', function () {
      $('.carousel').removeClass('hidden');
      $('.carousel').slick({
        dots: true,
        autoplay: true,
        autoplaySpeed: 5000,
        pauseOnFocus: false,
        pauseOnHover: false,
        pauseOnDotsHover: false,
        slidesToShow: 1,
        slidesToScroll: 1,
        fade: true,
        speed: 300,
        waitForAnimate: false,
        responsive: [],
      });
    });
  }
}
