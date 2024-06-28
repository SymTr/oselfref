# 目的: テストデータの作成を容易にする。
# 意味: 一貫性のあるテストデータを簡単に生成でき、テストの可読性と保守性を向上させる
# spec/factories/passkeys.rb
FactoryBot.define do
  factory :passkey do
    user
    label { 'Test Passkey' }
    sequence(:external_id) { |n| "external_id_#{n}" }
    public_key { SecureRandom.hex(32) }
    sign_count { 0 }
  end
end
