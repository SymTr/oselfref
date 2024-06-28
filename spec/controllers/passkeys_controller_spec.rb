# 目的: PasskeysController の各アクションの動作を検証する。
# 意味: リクエストに対して適切なレスポンスを返すか、認証が正しく機能するか、データベースの操作が正しく行われるかを確認する。
# spec/controllers/passkeys_controller_spec.rb
require 'rails_helper'

RSpec.describe PasskeysController, type: :controller do
  let(:user) { create(:user) }
  let(:passkey) { create(:passkey, user:) }

  before { sign_in user }

  describe 'GET #index' do
    it 'assigns @passkeys' do
      get :index
      expect(assigns(:passkeys)).to eq([passkey])
    end
  end

  describe 'GET #new' do
    it 'assigns a new passkey' do
      get :new
      expect(assigns(:passkey)).to be_a_new(Passkey)
    end

    it 'sets passkey_creation_challenge in session' do
      get :new
      expect(session[:passkey_creation_challenge]).to be_present
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        credential: {
          id: Base64.strict_encode64('test_id'),
          rawId: Base64.strict_encode64('test_id'),
          response: {
            attestationObject: Base64.strict_encode64('test_attestation'),
            clientDataJSON: Base64.strict_encode64('{"type":"webauthn.create","challenge":"test_challenge","origin":"http://localhost:3000"}')
          },
          type: 'public-key'
        }.to_json,
        passkey: { label: 'Test Passkey' }
      }
    end

    before do
      allow(WebAuthn::Credential).to receive(:from_create).and_return(
        double(verify: true, id: 'test_id', public_key: 'test_public_key', sign_count: 0)
      )
    end

    it 'creates a new passkey' do
      expect do
        post :create, params: valid_params, format: :json
      end.to change(Passkey, :count).by(1)
    end

    it 'returns a success JSON response' do
      post :create, params: valid_params, format: :json
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('success')
      expect(json_response['message']).to eq('Passkey was successfully created.')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the passkey' do
      passkey # 事前に作成
      expect do
        delete :destroy, params: { id: passkey.id }
      end.to change(Passkey, :count).by(-1)
    end

    it 'redirects to passkeys_path' do
      delete :destroy, params: { id: passkey.id }
      expect(response).to redirect_to(passkeys_path)
    end
  end
end
