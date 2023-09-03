class Users::RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    ## memo: フォローされたとき
    ## xxxさんがあなたをフォローしました
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
  end
end
