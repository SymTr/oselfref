# app/models/passkey.rb
class Passkey < ApplicationRecord
  belongs_to :user

  validates :label, presence: true
  validates :external_id, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :public_key, presence: true
  validates :sign_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.from_create(user, webauthn_credential, label = 'My Passkey')
    create!(
      user:,
      label:,
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )
  end

  def update_sign_count(new_sign_count)
    update!(sign_count: new_sign_count) if new_sign_count > sign_count
  end
end
