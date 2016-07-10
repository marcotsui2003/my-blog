class PostsController < ApplicationController
  def index
    @posts = Post.pick_blogger(params[:blogger_id]).by_category(params[:category])
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end
end
