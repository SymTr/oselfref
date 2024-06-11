# spec/requests/posts_spec.rb
require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  let(:user) { create(:user) }
  let!(:post_record) { create(:post, user: user) }
#let は遅延評価され、呼び出されたときに初めてコードブロックが評価される
 
  before do
    sign_in user
  end

  describe 'GET #index' do
    it '成功のレスポンスを返す' do
      get posts_path
      expect(response).to be_successful
    end

    it '現在のユーザーの投稿を返す' do
      get posts_path
      expect(response.body).to include(post_record.event)
    end
  end

  describe 'GET #new' do
    it '成功のレスポンスを返す' do
      get new_post_path
      expect(response).to be_successful
    end

    it '新しい投稿を作成できるフォームを表示する' do
      get new_post_path
      expect(response.body).to include('新規投稿')
    end
  end

  describe 'POST #create' do
    context '有効なパラメータの場合' do
      it '新しい投稿を作成する' do
        expect {
          post posts_path, params: { post: attributes_for(:post) }
        }.to change(Post, :count).by(1)
      end

      it '投稿一覧にリダイレクトする' do
        post posts_path, params: { post: attributes_for(:post) }
        expect(response).to redirect_to(posts_path)
      end
    end

    context '無効なパラメータの場合' do
      it '新しいテンプレートを表示する' do
        post posts_path, params: { post: attributes_for(:post, event: nil) }
        expect(response.body).to include('新規投稿')
      end
    end
  end
end
