require 'csv'

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :move_to_index, except: [:index]

  def index
    @posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(10) # ページネーションを追加

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@posts), filename: "posts-#{Date.today}.csv" }
    end
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
    params.require(:post).permit(:event, :emotions, :self_task, :other_task, :mood_after, :note,
                                 emotions: []).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  def generate_csv(posts)
    CSV.generate(headers: true) do |csv|
      csv << %w[投稿日時 出来事 感情 課題の分離 根拠 別の考え方 記入後の心境]
      posts.each do |post|
        csv << [
          post.created_at.strftime('%Y-%m-%d %H:%M'),
          post.event,
          post.emotions.join(', '),
          post.self_task,
          post.other_task,
          post.note,
          post.mood_after
        ]
      end
    end
  end
end