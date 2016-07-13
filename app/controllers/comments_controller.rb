class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :right_to_edit_comment?, except: [:index, :show, :new, :create]

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

  def right_to_edit_comment?
    #can expand here to take care of non-existent posts and comments!
    comment = Comment.find_by(id: params[:id])
    unless  comment.commenter == current_user && !comment.nil?
      return redirect_to post_path(params[:post_id]),
      alert: "You do not have right to create/modify this comment."
    end
  end

end
