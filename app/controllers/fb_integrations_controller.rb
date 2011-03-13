class FbIntegrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # before_filter :parse_facebook_cookies
  
  def login
    parse_facebook_cookies
    render :layout => false
  end
  
  def canvas_login
    sign_out
    fb_user = Koala::Facebook::OAuth.new.parse_signed_request(params[:signed_request])
    if fb_user
      authentication = Authentication.find_by_provider_and_uid('facebook', fb_user['user_id'])
      if authentication
        flash[:notice] = "Signed in successfully."
        sign_in( authentication.user )
        redirect_back_or authentication.user
      else
        # Try to sign_in with Facebook e-mail
        begin
          graph = Koala::Facebook::GraphAPI.new(fb_user["oauth_token"])
          profile = graph.get_object("me")
          user = User.find_by_email(profile["email"])
          if user
            # Create Facebook connection
            sign_in (user)
            current_user.authentications.create!(:provider => 'facebook', :uid => fb_user['user_id'])
            flash[:notice] = "User authenticated by email. Facebook connection created!"
            redirect_back_or user
          else
            flash[:notice] = "User not found. Sign up now!"
            @user = User.new(:email => profile["email"])
            @user.authentications.build(:provider => 'facebook', :uid => fb_user['user_id'])
            @title = "Sign up"
            render "users/new"
          end
        rescue Exception => e
          redirect_to "/auth/facebook"
          # flash[:notice] = "User not registered. Sign up now!"
          # render :login, :layout => false
          # =begin
            # TODO Add request permissions for users that haven't authorized yet.
          # =end
        end
      end
    end
  end
  
  private
  
  def parse_facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end
  

end
