module ApplicationHelper
  def has_user?
    !!params[:user_id]
  end
end
