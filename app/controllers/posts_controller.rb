class PostsController < ApplicationController
  def index
    @posts = Post.all
    # @postsという変数にPostモデルが管理するpostsテーブルすべてのレコードを代入
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: '保存されました'
    else 
      render :new
    end
  end

  private
  def post_params 
    params.require(:post).permit(:event, :emotions, :self_task, :other_task, :mood_after, :note)
  end 
  # def post_params 
  #   params.require(:post).permit(:event, :emotions, :self_task, :other_task, :mood_after, :note).merge(user_id: current_user.id)
  # end 
end
