class PostsController < ApplicationController
  # need before_action :authenticate_user! own_this_post?


  def index
    @blogger_id = params[:blogger_id]
    @category_id = params[:category_id]
    @date = params[:date]
    @posts = Post.pick_blogger(@blogger_id).by_category(@category_id).by_date(@date)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end



end
