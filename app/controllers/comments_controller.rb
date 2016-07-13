class CommentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @post= Post.find_by(id: params[:post_id])
    #must user build instead of create, otherwise form_for will
    #be sent to #update action!
    @comment = @post.comments.build
  end

  def create
    @post = Post.find(params[:post_id])
    if @post.nil?
      flash[:alert] = "No such post exists."
      return redirect_to posts_path
    else
      @comment = @post.comments.build(content: comment_params[:content],
                                    commenter: current_user)
      if @comment.save
        flash[:notice] = "Comment successfully created."
        return redirect_to post_path @post
      else
        render 'new'
      end
    end
  end

  


  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
