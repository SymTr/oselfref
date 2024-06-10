class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { within: 6..128 }

  has_many :posts, dependent: :destroy
end
