class PostsController < ApplicationController
  # need before_action :authenticate_user! own_this_post?
   before_action :authenticate_user!
   before_action :right_to_post?, except: [:index, :show]

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

  def edit
    @user = User.find_by(id: params[:user_id])
    @post = @user.posts.find_by(id: params[:id])
    2.times {@post.categories.build}
  end

  def update
    @user = User.find_by(id: params[:user_id])
    @post = @user.posts.find_by(id: params[:id])
    @post.attributes = post_params
    if @post.save
      flash[:notice] = "Post successfully created."
      return redirect_to post_path @post
    else
      render 'edit'
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, categories_attributes: [:name])
  end

  def right_to_post?
    unless params[:user_id].to_i == current_user.id
      return redirect_to posts_path, alert: "You do not have right to create/modify this post"
    end
  end

end
