require 'rails_helper'
# Rspecを用いてRailsの機能をテストするときに、共通の設定を書いておくファイル

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    it 'nicknameが空では登録できない' do
      user = User.new(nickname: '', email: 'test@example.com', password: 'password')
      user.valid?
      expect(user.errors.full_messages).to include("ニックネーム を入力してください")
    end

    it 'emailが空では登録できない' do
      user = User.new(nickname: 'testuser', email: '', password: 'password')
      user.valid?
      expect(user.errors.full_messages).to include("メールアドレス を入力してください")
    end
  end
end