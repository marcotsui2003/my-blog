module ApplicationHelper
  def has_user?
    !!params[:user_id]
  end

  def own_recipe?(recipe)
    recipe.user_id == current_user.id
  end

  def can_edit_comment?(comment)
    if comment.nil? || comment.commenter.nil? ||current_user.nil?
      false
    else
      comment.commenter_id == current_user.id
    end
  end

  def can_edit_reply?(reply)
    if reply.nil? || reply.replier.nil? ||current_user.nil?
      false
    else
      reply.replier == current_user
    end
  end
end
