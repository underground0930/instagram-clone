class Posts::LikesController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    ## memo: 自分の投稿にいいねがあったとき
    ## xxxさんがあなたの投稿にいいねしました
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.unlike(@post)
  end
end
