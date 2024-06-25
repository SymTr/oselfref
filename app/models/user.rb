class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :passkeys, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :nickname, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { within: 6..128 }

  def webauthn_id
    WebAuthn.generate_user_id(email)
  end
end