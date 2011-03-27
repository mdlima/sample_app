class AuthenticationsController < ApplicationController
  # skip_before_filter :verify_authenticity_token
  before_filter :authenticate, :except => [:create]
  before_filter :authorized_user, :only => :destroy
  
  def index
    @authentications = current_user.authentications if current_user
    @title = "Connections"
  end
  
  def create
    @title = "Sign In"
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid']) if omniauth
    if authentication
      if (current_user && current_user != authentication.user)
        flash[:notice] = "This #{omniauth['provider']} account is already connected to another user."
        redirect_to authentications_url
      else
        flash[:notice] = "Signed in successfully."
        sign_in( authentication.user )
        redirect_back_or authentication.user
      end
    elsif current_user
      authentication = current_user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
		if authentication.valid?
			authentication.save!
	      flash[:notice] = "Authentication successful."
		else
			flash[:notice] = "Invalid authentication."
		end
		redirect_to authentications_url
    else
      flash[:notice] = "User not found. Sign up now!"
      redirect_to signup_path
    #   user = User.new
    #   user.apply_omniauth(omniauth)
    #   if user.save
    #     flash[:notice] = "Signed in successfully."
    #     sign_in( user, false )
    #     redirect_back_or user
    #   else
    #     session[:omniauth] = omniauth.except('extra')
    #     redirect_to new_user_registration_url
    #   end
    end
  end

  def destroy
    @title = "Remove Connections"
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  private

    def authorized_user
      @authentication = Authentication.find(params[:id])
      redirect_to root_path unless current_user?(@authentication.user) || current_user.admin?
    end
end

