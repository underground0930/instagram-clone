class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to("/", success: "ログインに成功しました")
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new, status: :unprocessable_entity
    end
    
  end

  def destroy
    logout
    redirect_to("/", success: "ログアウトしました", status: :see_other)
  end
  
end
