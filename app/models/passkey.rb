# app/models/passkey.rb
class Passkey < ApplicationRecord
  belongs_to :user

  validates :external_id, presence: true, uniqueness: true
  validates :public_key, presence: true
  validates :sign_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.from_create(user, webauthn_credential)
    create!(
      user: user,
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )
  end

  def update_sign_count(new_sign_count)
    update!(sign_count: new_sign_count) if new_sign_count > sign_count
  end
end

# db/migrate/YYYYMMDDHHMMSS_create_passkeys.rb
class CreatePasskeys < ActiveRecord::Migration[7.0]
  def change
    create_table :passkeys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :external_id, null: false
      t.string :public_key, null: false
      t.integer :sign_count, default: 0, null: false

      t.timestamps
    end
    add_index :passkeys, :external_id, unique: true
  end
end