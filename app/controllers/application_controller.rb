class ApplicationController < ActionController::Base
  before_action :basic_auth, unless: :skip_basic_auth?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :email])
  end

  def skip_basic_auth?
    Rails.env.test? || Rails.env.development?
  end
end
