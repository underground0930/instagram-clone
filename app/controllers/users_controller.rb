class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[index show new create]
  before_action :guest_user_only, only: %i[new create]

  def index
    @pagy, @users = pagy(User.includes(avatar_attachment: { blob: :variant_records }).order(created_at: :desc), items: 5)
  end

  def show
    @user = User.find(params[:id])
    @pagy, @posts = pagy(@user.posts.with_attached_images.order(created_at: :desc), items: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      redirect_to root_path, success: t('controllers.users.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(update_user_params)
      redirect_to user_path(current_user), success: t('controllers.users.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_user_params
    if params[:user][:avatar].blank?
      params.require(:user).permit(:username, :email)
    else
      params.require(:user).permit(:username, :email, :avatar)
    end
  end
end
