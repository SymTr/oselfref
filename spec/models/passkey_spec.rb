# 目的: Passkey モデルの振る舞いを検証する。
# 意味: バリデーション、アソシエーション、カスタムメソッドが正しく機能することを確認し、データの整合性とビジネスロジックの正確性を保証する。
# spec/models/passkey_spec.rb
require 'rails_helper'

RSpec.describe Passkey, type: :model do
  let(:user) { create(:user) }
  subject { build(:passkey, user:) }

  describe 'validations' do
    it { should validate_presence_of(:label) }
    it { should validate_presence_of(:external_id) }
    it { should validate_uniqueness_of(:external_id).scoped_to(:user_id).case_insensitive }
    it { should validate_presence_of(:public_key) }
    it { should validate_presence_of(:sign_count) }
    it { should validate_numericality_of(:sign_count).is_greater_than_or_equal_to(0) }

    context 'when creating a passkey with the same external_id but different case' do
      let!(:existing_passkey) { create(:passkey, user:, external_id: 'test_id') }
      let(:new_passkey) { build(:passkey, user:, external_id: 'TEST_ID') }

      it 'is not valid' do
        expect(new_passkey).to be_invalid
        expect(new_passkey.errors[:external_id]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe '.from_create' do
    let(:webauthn_credential) { double(id: 'external_id', public_key: 'public_key', sign_count: 0) }

    it 'creates a new passkey' do
      expect do
        Passkey.from_create(user, webauthn_credential, 'Custom Label')
      end.to change(Passkey, :count).by(1)
    end
  end

  describe '#update_sign_count' do
    let(:passkey) { create(:passkey, user:) }

    it 'updates sign_count if new count is greater' do
      expect do
        passkey.update_sign_count(passkey.sign_count + 1)
      end.to change { passkey.reload.sign_count }.by(1)
    end

    it 'does not update sign_count if new count is not greater' do
      expect do
        passkey.update_sign_count(passkey.sign_count)
      end.not_to(change { passkey.reload.sign_count })
    end
  end
end
