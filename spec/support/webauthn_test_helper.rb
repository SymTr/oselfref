module WebAuthnTestHelper
  def mock_webauthn_creation_response(user)
    allow(WebAuthn::Credential).to receive(:options_for_create).and_return(
      OpenStruct.new(
        challenge: Base64.strict_encode64('test_challenge'),
        user_id: Base64.strict_encode64(user.id.to_s),
        public_key: {
          rp: { name: 'Test App', id: Capybara.current_session.server.host },
          user: {
            id: Base64.strict_encode64(user.id.to_s),
            name: user.email,
            displayName: user.email
          },
          challenge: Base64.strict_encode64('test_challenge'),
          pubKeyCredParams: [{ type: 'public-key', alg: -7 }],
          timeout: 60_000,
          attestation: 'direct',
          authenticatorSelection: {
            authenticatorAttachment: 'platform',
            userVerification: 'preferred'
          }
        }
      )
    )
  end

  def mock_webauthn_get_response(_user, passkey)
    allow(WebAuthn::Credential).to receive(:options_for_get).and_return(
      OpenStruct.new(
        challenge: Base64.strict_encode64('test_challenge'),
        allowCredentials: [
          { type: 'public-key', id: Base64.strict_encode64(passkey.external_id) }
        ],
        userVerification: 'preferred',
        timeout: 60_000
      )
    )
  end
end
