module ApplicationHelper
  def has_user?
    !!params[:user_id]
  end

  def own_post?(post)
    post.user_id == current_user.id
  end

end
