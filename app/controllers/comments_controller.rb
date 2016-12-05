class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :right_to_edit_comment?, except: [:index, :show, :new, :create]

  def new
    @recipe= Recipe.find_by(id: params[:recipe_id])
    #must user build instead of create, otherwise form_for will
    #be sent to #update action!
    @comment = @recipe.comments.build
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    if @recipe.nil?
      flash[:alert] = "No such recipe exists."
      return redirect_to recipes_path
    else
      @comment = @recipe.comments.build(content: comment_params[:content],
                                    commenter: current_user)
      if @comment.save
        flash[:notice] = "Comment successfully created."
        return redirect_to recipe_path @recipe
      else
        render 'new'
      end
    end
  end

  def edit
    @recipe = Recipe.find_by(id: params[:recipe_id])
    return redirect_to recipes_path, alert: "No such recipe." if @recipe.nil?
    @comment = @recipe.comments.find_by(id: params[:id])
    return redirect_to recipe_path(@recipe), alert: "Comment not found." if @comment.nil?
  end

  def update
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @comment = @recipe.comments.find_by(id: params[:id])
    @comment.attributes = comment_params
    if @comment.save
      flash[:notice] = "Comment successfully updated."
      return redirect_to recipe_path @recipe
    else
      render 'edit'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end

  def right_to_edit_comment?
    #can expand here to take care of non-existent recipes and comments!
    comment = Comment.find_by(id: params[:id])
    unless  comment.commenter == current_user && !comment.nil?
      return redirect_to recipe_path(params[:recipe_id]),
      alert: "You do not have right to create/modify this comment."
    end
  end

end
