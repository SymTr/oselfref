class PostsController < ApplicationController
  def index
    @posts = Post.all
    # @postsという変数にPostモデルが管理するpostsテーブルすべてのレコードを代入
  end
end
