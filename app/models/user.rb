class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  
 def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create an user with a stub password. 
      user = User.create!(:email => data["email"], :password => Devise.friendly_token[0,20]) 
    end
    auth       = user.authentications.find_or_create_by_provider_and_uid(access_token['provider'], access_token['uid'])
    auth.token = access_token['credentials']['token']
    auth.save!
    user
    
 end 
 
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"]
        user.email = data["email"]
      end
    end
  end
  
  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end
  
end
