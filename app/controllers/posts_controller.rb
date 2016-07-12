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

  def new
    @user = User.find_by(id: params[:user_id])
    @post = @user.posts.build
    5.times {@post.categories.build}
  end

  def create
    @user = User.find_by(id: params[:user_id])
    @post = Post.new(post_params)
    @post.user_id = params[:user_id]
    if @post.save
      flash[:notice] = "Post successfully created."
      return redirect_to post_path @post
    else
      render 'new'
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, categories_attributes: [:name])
  end

end
