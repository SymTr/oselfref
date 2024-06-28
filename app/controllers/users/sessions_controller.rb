class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def new
    super
  end

  def create
    user = User.find_by(email: params[:user][:email])

    if user && user.passkeys.any? && !params[:password_login]
      handle_passkey_authentication(user)
    else
      handle_password_authentication
    end
  rescue StandardError => e
    handle_authentication_error(e)
  end

  def passkey_authenticate
    unless valid_passkey_session?
      return render json: { status: 'error', message: 'Authentication session expired' }, status: :unprocessable_entity
    end

    user = User.find_by(email: session[:passkey_authentication_email])
    raise StandardError, 'User not found' unless user

    webauthn_credential = WebAuthn::Credential.from_get(params[:credential])
    passkey = user.passkeys.find_by(external_id: webauthn_credential.id)
    raise StandardError, 'Invalid credentials' unless passkey

    begin
      webauthn_credential.verify(
        session[:passkey_authentication_challenge],
        public_key: passkey.public_key,
        sign_count: passkey.sign_count
      )

      passkey.update!(sign_count: webauthn_credential.sign_count)
      sign_in(user)
      render json: { status: 'success', redirect_url: after_sign_in_path_for(user) }
    rescue WebAuthn::Error => e
      render json: { status: 'error', message: e.message }, status: :unprocessable_entity
    ensure
      clear_passkey_session
    end
  end

  private

  def handle_passkey_authentication(user)
    options = WebAuthn::Credential.options_for_get(
      allow: user.passkeys.pluck(:external_id),
      user_verification: 'preferred'
    )
    set_passkey_session(options, user.email)
    render json: { publicKey: options }
  end

  def handle_password_authentication
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def handle_authentication_error(error)
    respond_to do |format|
      format.html do
        flash[:alert] = "Authentication failed: #{error.message}"
        redirect_to new_user_session_path
      end
      format.json do
        render json: { error: error.message }, status: :unprocessable_entity
      end
    end
  end

  def set_passkey_session(options, email)
    session[:passkey_authentication_challenge] = options.challenge
    session[:passkey_authentication_email] = email
    session[:passkey_authentication_expires_at] = 5.minutes.from_now.to_i
  end

  def valid_passkey_session?
    session[:passkey_authentication_challenge].present? &&
      session[:passkey_authentication_email].present? &&
      session[:passkey_authentication_expires_at].to_i > Time.now.to_i
  end

  def clear_passkey_session
    session.delete(:passkey_authentication_challenge)
    session.delete(:passkey_authentication_email)
    session.delete(:passkey_authentication_expires_at)
  end
end
