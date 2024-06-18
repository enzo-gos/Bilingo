// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import 'controllers';

import jquery from 'jquery';
import 'slick-carousel';

window.jQuery = jquery;
window.$ = jquery;

import "trix"
import "@rails/actiontext"
