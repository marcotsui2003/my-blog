class RepliesController < ApplicationController
  before_action :authenticate_user!
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
    post= Post.find(params[:post_id])
    if post.nil?
      flash[:alert] = "No such post exists."
      return redirect_to posts_path
    else
      reply = Reply.new(reply_params)
      reply.post = post
      reply.replier_id = current_user.id
      if reply.save
        flash[:notice] = "reply successfully created."
      else
        flash[:alert] = "reply fails to be created."
      end
      return redirect_to post_path post
    end
  end


  private
  def reply_params
    params.require(:reply).permit(:content, :repliable_id, :repliable_type)
  end

end