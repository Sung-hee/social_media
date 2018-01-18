class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # skip_before_action :verify_authenticity_token, only: [:show]

  def authorize # 로그인 되었는지 판별해라
    redirect_to '/users/sign_in' unless current_user
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where("tag LIKE ?", "%#{params["q"]}%").reverse # 태그로 검색한거만 보여줌
    # Post.where(['created_at < ?', 30.seconds.ago]).destroy_all
    # Plus like
    std_time = 2
    plus_time = 1
    pre_std_time = std_time-1

    # 기존 일정보다 하루 더 빨리
    post = Post.where(['created_at < ?', pre_std_time.minutes.ago])

    #삭제
    post.each do |post|

      if post.likes != nil
        like_count = post.likes.count
        tmp_total_time = std_time + (like_count * plus_time)
        post.update(total_time: tmp_total_time)
        Post.where(['created_at < ?', post.total_time.minutes.ago]).destroy_all
      else
        # post.destroy
        post.update(total_time: std_time)
        Post.where(['created_at < ?', std_time.minutes.ago]).destroy_all
      end


      #삭제알림
      delete_time = post.total_time - 1

      # @delete_msg = false
      status = false

      post.update(status: status)

      delete_post = Post.where(['created_at < ?', delete_time.minutes.ago])

      delete_post.each do |post|
        # @delete_msg = true
        status = true
        post.update(status: status)
      end
    end
  end

  def my_feed
    @posts = Post.where(user_id: current_user.id).reverse
  end
  # GET /posts/1
  # GET /posts/1.json
  def show
    # @posts = Post.all
    if user_signed_in?
      @like = Like.where(user_id: current_user.id, post_id: params[:id])
    else
      @like = []
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_like_post
    @like = Like.where(user_id: current_user.id, post_id: params[:post_id]).first

    unless @like.nil?
      @like.destroy
      puts '좋아요 취소'

    else
      @like = Like.create(user_id: current_user.id, post_id: params[:post_id])
      puts '좋아요 누름'
    end
  end

  def create_comment
    @comment = Comment.create(
      user_id: current_user.id,
      post_id: params[:id],
      contents: params[:contents]
    )
  end

  def delete_comment
    @comment = Comment.find(params[:comment_id])
    if @comment.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :tag, :user_id, :image)
    end
end
