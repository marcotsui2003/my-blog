class PostsController < ApplicationController
  def index
    if params[:user_id]
      @posts = Post.where(user_id: params[:user_id])
    else
      @posts = Post.all
    end
  end
end
