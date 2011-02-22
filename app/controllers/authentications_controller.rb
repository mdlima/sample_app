class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
    @title = "Connections"
  end
  
  def create
    @title = "Sign In"
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in( authentication.user, false )
      redirect_back_or authentication.user
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
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
    @title = "Sign Out"
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
