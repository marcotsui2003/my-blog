class RegistrationsController < Devise::RegistrationsController

  def twitter_new
    @user = User.new
    @user.password = Devise.friendly_token[0,10]
    @user.password_confirmation = @user.password
  end

  def twitter_create
    @user = User.find_or_initialize_by(user_params) do |user|
      user.password = Devise.friendly_token[0,10]
      user.password_confirmation = user.password
    end

    if @user.save
      @user.authorizations.create(:provider => "twitter",
      :uid => session["twitter_auth"]['uid'].to_s,
      :token => session["twitter_auth"]['credentials']['token'],
      :secret => session["twitter_auth"]['credentials']['secret'])
      session.delete(:twitter_auth)
      return sign_in_and_redirect @user
    else
      session.delete(:twitter_auth)
      flash[:alert] = "Twitter login unsuccessful. Please try again."
      return redirect_to new_user_registration_path
    end
  end

  protected
  def after_update_path_for(resource)
      user_posts_path(resource)
  end

  private
  def user_params
    params.require(:user).permit(:email, :avatar)
  end


end
