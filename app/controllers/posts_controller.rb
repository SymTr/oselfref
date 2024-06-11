class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :move_to_index, except: [:index]
  
  def index
    @posts = current_user.posts.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, notice: '保存されました'
    else 
      render :new, status: :unprocessable_entity
    end
  end

  private
  def post_params 
    params.require(:post).permit(:event, :emotions, :self_task, :other_task, :mood_after, :note, emotions: []).merge(user_id: current_user.id)
  end 
  
  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end
