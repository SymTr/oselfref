class PasskeysController < ApplicationController
  before_action :authenticate_user!

  def index
    @passkeys = current_user.passkeys
  end

  def new
    @passkey = current_user.passkeys.new
    options = WebAuthn::Credential.options_for_create(
      user: {
        id: current_user.webauthn_id,
        name: current_user.email,
        display_name: current_user.nickname
      },
      exclude: current_user.passkeys.pluck(:external_id),
      authenticator_selection: {
        user_verification: 'preferred',
        resident_key: 'preferred'
      }
    )
    session[:passkey_creation_challenge] = options.challenge

    respond_to do |format|
      format.html
      format.json { render json: { publicKey: options } }
    end
  end

  def create
    webauthn_credential = WebAuthn::Credential.from_create(params[:credential])
    webauthn_credential.verify(session[:passkey_creation_challenge])

    passkey = current_user.passkeys.create!(
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count,
      label: params[:passkey][:label]
    )

    render json: { status: 'success', message: 'Passkey was successfully created.' }
  rescue WebAuthn::Error, ActiveRecord::RecordInvalid => e
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  ensure
    session.delete(:passkey_creation_challenge)
  end

  def destroy
    passkey = current_user.passkeys.find(params[:id])
    passkey.destroy
    redirect_to passkeys_path, notice: 'Passkey was successfully deleted.'
  end

  private

  def passkey_params
    params.require(:passkey).permit(:label)
  end
end
