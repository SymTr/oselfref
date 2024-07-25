require 'csv'

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :move_to_index, except: [:index]

  def index
    @posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(10) # ページネーション

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
    params.require(:post).permit(:situation, :thoughts, :self_task, :others_task, 
                                 :supporting_evidence, :contrary_evidence, 
                                 :alternative_thinking, :mood_after, emotions: []).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  def generate_csv(posts)
    CSV.generate(headers: true) do |csv|
      csv << %w[投稿日時 できごと 考え 感情 自分の課題 他者の課題 肯定する証拠 反する証拠 他の考え方 記入後の感情]
      posts.each do |post|
        csv << [
          post.created_at.strftime('%Y-%m-%d %H:%M'),
          post.situation,
          post.thoughts,
          post.emotions.join(', '),
          post.self_task,
          post.others_task,
          post.supporting_evidence,
          post.contrary_evidence,
          post.alternative_thinking,
          post.mood_after
        ]
      end
    end
  end
end