# config/initializers/webauthn.rb
WebAuthn.configure do |config|
  config.origin = Rails.env.production? ? "https://oselfref.onrender.com" : "http://localhost:3000"
  config.rp_name = "Self Reflection App "
  config.rp_id = Rails.env.production? ? "oselfref.onrender.com" : "localhost"
end