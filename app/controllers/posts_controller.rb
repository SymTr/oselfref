class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc)
    
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, notice: '保存されました'
    else 
      render :new
    end
  end

  private
  def post_params 
    params.require(:post).permit(:event, :emotions, :self_task, :other_task, :mood_after, :note, emotions: [])
  end 
  # def post_params 
  #   params.require(:post).permit(:event, :emotions, :self_task, :other_task, :mood_after, :note).merge(user_id: current_user.id)
  # end 
end
