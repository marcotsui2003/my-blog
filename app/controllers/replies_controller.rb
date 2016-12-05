class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :right_to_edit_reply?, only: [:edit, :update]

  def new
    @recipe = Recipe.find_by(id: params[:recipe_id])
    return recipes_path if @recipe.nil?
    if params[:type] != "Comment" && params[:type]!= "Reply"
      flash["alert"] = "Invalid message type, reply failed."
      return redirect_to recipe_path @recipe
    end
    @repliable = Object.const_get(params[:type]).find_by(id: params[:id])
    return redirect_to recipe_path(recipe), alert: 'No such comment or reply.' unless !@repliable.nil?
    @reply = @repliable.replies.build( repliable_type: @repliable.class.name,
                                       repliable_id: @repliable.id)
  end

  def create
    @recipe= Recipe.find(params[:recipe_id])
    @repliable = Object.const_get(reply_params[:repliable_type]).find_by(id: reply_params[:repliable_id])
    if @recipe.nil?
      flash[:alert] = "No such recipe exists."
      return redirect_to recipes_path
    else
      @reply = @recipe.replies.build(reply_params)
      @reply.replier_id = current_user.id
      if @reply.save
        flash[:notice] = "reply successfully created."
        return redirect_to recipe_path @recipe
      else
        render 'new'
      end
    end
  end

  def edit
    @recipe = Recipe.find_by(id: params[:recipe_id])
    return recipes_path, alert: "No such recipe." if @recipe.nil?
    @reply = @recipe.replies.find_by(id: params[:id])
    @repliable = Object.const_get(@reply.repliable_type).find_by(id: @reply.repliable_id)
  end

  def update
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @reply = @recipe.replies.find_by(id: params[:id])
    @repliable = Object.const_get(@reply.repliable_type).find_by(id: @reply.repliable_id)
    return recipes_path, alert: "No such recipe." if @recipe.nil?
    @reply.attributes = reply_params
    if @reply.save
      return redirect_to recipe_path(@recipe), notice: "Reply successfully updated."
    else
      render "edit"
    end
  end



  private
  def reply_params
    params.require(:reply).permit(:content, :repliable_id, :repliable_type)
  end

  def right_to_edit_reply?
    reply = Reply.find_by(id: params[:id])
    unless  reply.replier == current_user && !reply.nil?
      return redirect_to recipe_path(params[:recipe_id]),
      alert: "You do not have right to create/modify this reply."
    end
  end

end
