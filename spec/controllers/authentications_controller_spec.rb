require 'spec_helper'

describe AuthenticationsController do
  render_views

	
	describe "GET 'index'" do

		describe "for non-signed-in users" do
			it "should deny access" do
				get :index
				response.should redirect_to(signin_path)
				flash[:notice].should =~ /sign in/i
			end
		end

		describe "for signed-in users" do

			before(:each) do
        @user = test_sign_in(Factory(:user))
			end

			it "should be successful" do
				get :index
				response.should be_success
			end

			it "should have the right title" do
				get :index
				response.should have_selector("title", :content => "Connections")
			end

=begin
  TODO Add validations for loging in, creating and destroying authentications
=end
      # it "should have an element for each user" do
      #   get :index
      #   @users[0..2].each do |user|
      #     response.should have_selector("li", :content => user.name)
      #   end
      # end

		end
	end

	describe "GET 'create'" do
  end
  
  describe "GET 'destroy'" do
	end
	  
end
