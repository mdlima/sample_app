class FbIntegrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :parse_facebook_cookies
  
  def login
    render :layout => false
  end
  
  private
  
  def parse_facebook_cookies
    @facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end
  

end
