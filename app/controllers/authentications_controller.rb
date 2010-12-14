class AuthenticationsController < ApplicationController
  def index
    #current_user.facebook.feed!(:message => 'Hello, Facebook!', :name => 'My Rails 3 App with Omniauth, Devise and FB_graph') if current_user
    @authentications = current_user.authentications if current_user
  end
  
  
  def destroy
    if current_user
        @authentication = current_user.authentications.find(params[:id]) 
        @authentication.destroy
        flash[:notice] = "Successfully destroyed authentication."
    end
    redirect_to authentications_url
  end
end
