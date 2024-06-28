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

        raise(:not_found_in_database) unless user

        if user.passkeys.any?
          session[:passkey_authentication_user_id] = user.id
          custom!([401, { 'Content-Type' => 'application/json' }, [{ status: 'passkey_required' }.to_json]])
        else
          pass # パスキーが登録されていない場合は、通常の認証に進む
        end
      end
    end
  end
end

Warden::Strategies.add(:webauthn, Devise::Strategies::Webauthn)
