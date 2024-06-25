# app/controllers/passkeys_controller.rb
class PasskeysController < ApplicationController
  before_action :authenticate_user!

  def new
    @passkey = current_user.passkeys.new
  end

  def create
    options = WebAuthn::Credential.options_for_create(
      user: {
        id: current_user.webauthn_id,
        name: current_user.email
      },
      exclude: current_user.passkeys.pluck(:external_id)
    )
    session[:passkey_creation_challenge] = options.challenge
    render json: options
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_create(params[:credential])
    webauthn_credential.verify(session[:passkey_creation_challenge])

    passkey = Passkey.from_create(current_user, webauthn_credential)
    render json: { status: 'success', message: 'Passkey registered successfully' }
  rescue WebAuthn::Error => e
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  ensure
    session.delete(:passkey_creation_challenge)
  end

  def index
    @passkeys = current_user.passkeys
  end

  def destroy
    passkey = current_user.passkeys.find(params[:id])
    passkey.destroy
    redirect_to passkeys_path, notice: 'Passkey was successfully deleted.'
  end
end