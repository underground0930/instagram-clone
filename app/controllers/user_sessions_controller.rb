class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to('/', success: t('controllers.user_sessions.create.success'))
    else
      flash.now[:danger] = t('controllers.user_sessions.create.danger')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to('/', success: t('controllers.user_sessions.destroy.success'), status: :see_other)
  end
end
