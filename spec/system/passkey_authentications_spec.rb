require 'rails_helper'

RSpec.describe "PasskeyAuthentications", type: :system do
  pending "システムテストは現在開発中です" do
  let(:user) { create(:user) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "Passkey registration" do
    before do
      sign_in user
      visit new_passkey_path
    end

    it "allows user to register a new passkey", js: true do
      fill_in "パスキーの名前", with: "My Test Passkey"
      
      mock_webauthn_creation_response(user)

      page.execute_script(<<~JS)
        window.create = () => Promise.resolve({
          id: 'test_credential_id',
          rawId: new Uint8Array([1, 2, 3, 4]).buffer,
          response: {
            clientDataJSON: 'test_client_data',
            attestationObject: 'test_attestation'
          },
          type: 'public-key'
        });
      JS

      click_button "パスキーを登録"

      expect(page).to have_content("パスキーが正常に登録されました", wait: 10)
    end
  end

  describe "Passkey login" do
    let!(:passkey) { create(:passkey, user: user) }

    before do
      visit new_user_session_path
    end

    it "allows user to login with a passkey", js: true do
      mock_webauthn_get_response(user, passkey)

      page.execute_script(<<~JS)
        window.get = () => Promise.resolve({
          id: '#{Base64.strict_encode64(passkey.external_id)}',
          rawId: new Uint8Array([1, 2, 3, 4]).buffer,
          response: {
            clientDataJSON: 'test_client_data',
            authenticatorData: 'test_authenticator_data',
            signature: 'test_signature',
            userHandle: 'test_user_handle'
          },
          type: 'public-key'
        });
      JS

      click_button "パスキーでログイン"

      expect(page).to have_content("ログインしました", wait: 10)
    end
  end
end