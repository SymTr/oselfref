// app/javascript/application.js
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { base64URLStringToBuffer, bufferToBase64URLString } from 'helpers/webauthn_helper'

window.base64URLStringToBuffer = base64URLStringToBuffer;
window.bufferToBase64URLString = bufferToBase64URLString;