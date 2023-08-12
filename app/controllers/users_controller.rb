class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[index show new create]
  before_action :guest_user_only, only: %i[new create]

  def index
    @pagy, @users = pagy(User.order(created_at: :desc), items: 5)
  end

  def show
    @user = User.find(params[:id])
    @pagy, @posts = pagy(@user.posts.with_attached_images.order(created_at: :desc), items: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: t('controllers.users.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
