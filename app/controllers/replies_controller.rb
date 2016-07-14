class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :right_to_edit_reply?, only: [:edit, :update]

  def new
    @post = Post.find_by(id: params[:post_id])
    return posts_path if @post.nil?
    if params[:type] != "Comment" && params[:type]!= "Reply"
      flash["alert"] = "Invalid message type, reply failed."
      return redirect_to post_path @post
    end
    @repliable = Object.const_get(params[:type]).find_by(id: params[:id])
    return redirect_to post_path(post), alert: 'No such comment or reply.' unless !@repliable.nil?
    @reply = @repliable.replies.build( repliable_type: @repliable.class.name,
                                       repliable_id: @repliable.id)
  end

  def create
    @post= Post.find(params[:post_id])
    @repliable = Object.const_get(reply_params[:repliable_type]).find_by(id: reply_params[:repliable_id])
    if @post.nil?
      flash[:alert] = "No such post exists."
      return redirect_to posts_path
    else
      @reply = @post.replies.build(reply_params)
      @reply.replier_id = current_user.id
      if @reply.save
        flash[:notice] = "reply successfully created."
        return redirect_to post_path @post
      else
        render 'new'
      end
    end
  end

  def edit
    @post = Post.find_by(id: params[:post_id])
    return posts_path, alert: "No such post." if @post.nil?
    @reply = @post.replies.find_by(id: params[:id])
    @repliable = Object.const_get(@reply.repliable_type).find_by(id: @reply.repliable_id)
  end

  def update
    @post = Post.find_by(id: params[:post_id])
    @reply = @post.replies.find_by(id: params[:id])
    @repliable = Object.const_get(@reply.repliable_type).find_by(id: @reply.repliable_id)
    return posts_path, alert: "No such post." if @post.nil?
    @reply.attributes = reply_params
    if @reply.save
      return redirect_to post_path(@post), notice: "Reply successfully updated."
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
    unless  reply.post.user == current_user && !reply.nil?
      return redirect_to post_path(params[:post_id]),
      alert: "You do not have right to create/modify this reply."
    end
  end

end
