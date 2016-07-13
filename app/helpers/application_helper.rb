module ApplicationHelper
  def has_user?
    !!params[:user_id]
  end

  def own_post?(post)
    post.user_id == current_user.id
  end

  def can_edit_comment?(comment)
    if comment.nil? || comment.commenter.nil? ||current_user.nil?
      false
    else
      comment.commenter_id == current_user.id
    end
  end

  

end
