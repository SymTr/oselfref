# config/initializers/webauthn.rb
WebAuthn.configure do |config|
  case Rails.env
  when 'production'
    config.origin = ENV['WEBAUTHN_ORIGIN'] || "https://oselfref.onrender.com"
    config.rp_id = ENV['WEBAUTHN_RP_ID'] || "oselfref.onrender.com"
  when 'development'
    config.origin = "http://localhost:3000"
    config.rp_id = "localhost"
  when 'test'
    config.origin = "http://localhost"
    config.rp_id = "localhost"
  end

  config.rp_name = "Self Reflection App"
end