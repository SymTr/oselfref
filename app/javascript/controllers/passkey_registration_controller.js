import { Controller } from "@hotwired/stimulus"
import { create } from "@github/webauthn-json"

export default class extends Controller {
  static targets = [ "label" ]

  async register(event) {
    event.preventDefault();
    
    try {
      const response = await fetch('/passkeys/new', {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content
        }
      });
      
      if (!response.ok) {
        throw new Error('Failed to fetch options');
      }

      const data = await response.json();
      console.log('Received data:', data);  // デバッグ用ログ
      
      if (!data || !data.publicKey || !data.publicKey.challenge) {
        throw new Error('Invalid public key data received');
      }

      const credential = await create(data);
      console.log('Created credential:', credential);  // デバッグ用ログ
      
      const verifyResponse = await fetch('/passkeys', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content
        },
        body: JSON.stringify({
          credential: credential,
          passkey: { label: this.labelTarget.value }
        })
      });
      
      if (!verifyResponse.ok) {
        const errorData = await verifyResponse.json();
        throw new Error(errorData.message || 'Failed to verify credential');
      }

      const result = await verifyResponse.json();
      if (result.status === 'success') {
        alert('パスキーが正常に登録されました！');
        window.location.href = '/passkeys';
      } else {
        throw new Error(result.message || 'Failed to register passkey');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('パスキーの登録中にエラーが発生しました: ' + error.message);
    }
  }
}