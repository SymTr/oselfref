require 'rails_helper'

RSpec.describe 'できごと投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post_text = Faker::Lorem.sentence
  end

  context 'できごと投稿ができるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)

      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('新規投稿')

      # 投稿ページに移動する
      visit new_post_path

      # 投稿内容を入力する
      fill_in '何がありましたか？起きたことを書いてみましょう', with: @post_text
      fill_in '自分の課題（自分が変えられること）は何ですか？', with: Faker::Lorem.sentence
      fill_in '他者の課題（自分には変えられないこと）は何ですか？', with: Faker::Lorem.sentence
      fill_in 'どんな感情が出てきましたか？課題の分離を行うことで感情に変化があったかどうか記録しましょう', with: Faker::Lorem.sentence
      fill_in '備考：その他自由に記載しましょう', with: Faker::Lorem.sentence

      # 'emotions' is a checkbox group, so we check some emotions.
      check 'post_emotions_喜び'
      check 'post_emotions_悲しみ'

      # 投稿ボタンを押す
      find('input[name="commit"]').click

      # 投稿一覧ページには先ほど投稿した内容のできごとが存在することを確認する
      expect(page).to have_content(@post_text)
    end
  end

  context 'できごと投稿ができないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # 新規投稿ページに遷移する
      visit new_post_path

      # ログインページにリダイレクトされることを確認する
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
