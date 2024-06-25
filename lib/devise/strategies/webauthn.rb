# lib/devise/strategies/webauthn.rb
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class Webauthn < Authenticatable
      def valid?
        params[:user] && params[:user][:email]
      end

      def authenticate!
        user = User.find_by(email: params[:user][:email])

        if user && user.passkeys.any?
          session[:passkey_authentication_email] = user.email
          custom!([401, { 'Content-Type' => 'application/json' }, [{ status: 'passkey_required' }.to_json]])
        else
          pass
        end
      end
    end
  end
end

Warden::Strategies.add(:webauthn, Devise::Strategies::Webauthn)