class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    # @posts = Post.with_attached_images.includes(:user).order(created_at: :desc)
    # @posts = Post.with_attached_images.includes(:user).order(created_at: :desc)
    @pagy, @posts = pagy(Post.with_attached_images.includes(:user).order(created_at: :desc), items: 15)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
    @post = current_user.posts.build(create_post_params)
    if @post.save
      redirect_to post_path(@post), success: t('controllers.post.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find_by(id: params[:id])
    if @post.update(update_post_params)
      redirect_to post_path(@post), success: t('controllers.post.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    if @post.destroy
      redirect_to posts_path, success: t('controllers.post.destroy.success'), status: :see_other
    else
      redirect_to posts_path, danger: t('controllers.post.destroy.danger'), status: :unprocessable_entity
    end
  end

  private

  def create_post_params
    params.require(:post).permit(:body, images: [])
  end

  def update_post_params
    if params[:post][:images].blank?
      params.require(:post).permit(:body)
    else
      params.require(:post).permit(:body, images: [])
    end
  end
end
