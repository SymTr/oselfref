// app/javascript/controllers/passkey_authentication_controller.js
import { Controller } from "@hotwired/stimulus"
import { get } from "@github/webauthn-json"

export default class extends Controller {
  static targets = ["email"]

  async authenticate(event) {
    event.preventDefault()
    try {
      const email = this.emailTarget.value
      const options = await this.getAuthenticationOptions(email)
      const credential = await get(options)
      await this.verifyAuthentication(email, credential)
    } catch (error) {
      console.error('Passkey authentication failed:', error)
      alert('Passkey authentication failed. Please try again.')
    }
  }

  async getAuthenticationOptions(email) {
    const response = await fetch('/users/sign_in', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ user: { email } })
    })
    return response.json()
  }

  async verifyAuthentication(email, credential) {
    const response = await fetch('/users/passkey_authenticate', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ email, credential })
    })
    const result = await response.json()
    if (response.ok) {
      window.location.reload()
    } else {
      alert('Authentication failed: ' + result.message)
    }
  }
}