import { Controller } from "@hotwired/stimulus"
import { get } from "@github/webauthn-json"

export default class extends Controller {
  static targets = [ "email" ]

  async authenticate(event) {
    event.preventDefault();
    const email = this.emailTarget.value;

    try {
      const response = await fetch('/users/sign_in', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content
        },
        body: JSON.stringify({ user: { email: email } })
      });

      if (!response.ok) {
        throw new Error('Failed to start authentication');
      }

      const data = await response.json();
      console.log('Received data:', data);  // デバッグ用ログ

      if (!data || !data.publicKey || !data.publicKey.challenge) {
        throw new Error('Invalid public key data received');
      }

      const credential = await get(data);
      console.log('Got credential:', credential);  // デバッグ用ログ

      const verifyResponse = await fetch('/users/passkey_authenticate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content
        },
        body: JSON.stringify({ credential: credential })
      });

      if (!verifyResponse.ok) {
        const errorData = await verifyResponse.json();
        throw new Error(errorData.message || 'Failed to verify credential');
      }

      const result = await verifyResponse.json();
      if (result.status === 'success') {
        window.location.href = result.redirect_url;
      } else {
        throw new Error(result.message || 'Authentication failed');
      }
    } catch (error) {
      console.error('Authentication error:', error);
      alert('認証に失敗しました: ' + error.message);
    }
  }
}