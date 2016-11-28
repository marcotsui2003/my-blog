class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  validates_presence_of :email

  has_many :authorizations
  has_many :posts
  has_many :categories, through: :posts
  has_many :comments, foreign_key: :commenter_id, inverse_of: :commenter
  has_many :commented_posts, through: :comments, source: :post
  #foreign_key is necessary here otherwise replies.user_id is used instead when
  #user.replies is called
  has_many :replies, foreign_key: :replier_id, inverse_of: :replier
  #avatar using paperclip
  # remember to refresh after modifying styles  by >>rake paperclip:refresh:thumbnails CLASS=User in CL
  # missing.png should be in assets/images/:style/missing.png
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "25x25#" }, :default_url => ":style/missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      #authorizations created previously must belong to a user(should add dependent :destroy)
      #so authorization.user blank means it is created for the first time
      user = current_user || (User.where('email = ?', auth["info"]["email"]).first) # will break if use twitter without logging in
      if user.blank?
       # means that this social login not connected to any existing user accounts
       # and the user is not already logged in
       user = User.new
       user.password = Devise.friendly_token[0,10]
       #if auth.provider == "twitter"
       # user.save(:validate => false)
       # need to redirect to edit profile!!
       user.username = auth.info.name
       user.email = auth.info.email
       user.save
       end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
    end
    authorization.user
  end

  def self.from_twitter(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user
      if user.blank?
        return User.new
      end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
    end
    authorization.user
  end
end
