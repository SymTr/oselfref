# 目的: ユーザーの視点からパスキー機能全体の動作を検証する。
# 意味: ブラウザでの操作をシミュレートし、実際のユーザー体験に近い形でテストを行い、機能の統合性を確認する。
# spec/system/passkeys_spec.rb
require 'rails_helper'

RSpec.describe 'Passkey management', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it 'allows user to view passkeys' do
    create(:passkey, user:, label: 'Test Passkey')
    visit passkeys_path
    expect(page).to have_content('Test Passkey')
  end

  it 'allows user to navigate to new passkey page' do
    visit passkeys_path
    click_link '新しいパスキーを登録'
    expect(page).to have_current_path(new_passkey_path)
  end

  # 注: WebAuthnの実際の動作をシステムスペックでテストするのは難しいため、
  # UIの表示や基本的なナビゲーションのみをテストしています。
end
