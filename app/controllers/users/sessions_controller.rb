class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])
    
    if user && user.passkeys.any?
      # パスキーが登録されている場合、パスキー認証のオプションを提供
      options = WebAuthn::Credential.options_for_get(
        allow: user.passkeys.pluck(:external_id),
        user_verification: 'preferred'
      )
      session[:passkey_authentication_challenge] = options.challenge
      session[:passkey_authentication_email] = user.email
      render json: options
    else
      # パスキーが登録されていない場合、通常のパスワード認証を実行
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  rescue
    flash.now[:alert] = "Invalid email or password."
    render :new, status: :unprocessable_entity
  end

  def passkey_authenticate
    user = User.find_by(email: session[:passkey_authentication_email])
    raise StandardError, 'User not found' unless user

    webauthn_credential = WebAuthn::Credential.from_get(params[:credential])
    passkey = user.passkeys.find_by(external_id: webauthn_credential.id)

    raise StandardError, 'Passkey not found' unless passkey

    webauthn_credential.verify(
      session[:passkey_authentication_challenge],
      public_key: passkey.public_key,
      sign_count: passkey.sign_count
    )

    passkey.update!(sign_count: webauthn_credential.sign_count)

    sign_in(user)
    render json: { status: 'success', redirect_url: after_sign_in_path_for(user) }
  rescue StandardError => e
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  ensure
    session.delete(:passkey_authentication_challenge)
    session.delete(:passkey_authentication_email)
  end
end