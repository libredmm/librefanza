// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
window.process = { env: { NODE_ENV: 'production' } };
import '@popperjs/core'
import 'bootstrap'
import 'controllers'

import ClipboardJS from 'clipboard'
new ClipboardJS('.btn');
