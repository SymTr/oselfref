// app/javascript/controllers/passkey_registration_controller.js
import { Controller } from "@hotwired/stimulus"
import { create } from "@github/webauthn-json"

export default class extends Controller {
  async register(event) {
    event.preventDefault()
    try {
      const response = await fetch('/passkeys/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      const options = await response.json()
      const credential = await create(options)
      await this.verifyRegistration(credential)
    } catch (error) {
      console.error('Passkey registration failed:', error)
      alert('Passkey registration failed. Please try again.')
    }
  }

  async verifyRegistration(credential) {
    const response = await fetch('/passkeys/callback', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ credential })
    })
    const result = await response.json()
    if (result.status === 'success') {
      alert('Passkey registered successfully')
      window.location.href = '/passkeys'
    } else {
      alert('Passkey registration failed: ' + result.message)
    }
  }
}
