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

			# it "should have an element for each user" do
			#		get :index
			#		@users[0..2].each do |user|
			#			response.should have_selector("li", :content => user.name)
			#		end
			# end

		end
	end

	describe "GET 'create'" do
	
		describe "for non-signed-in users" do
		  
		  before(:each) do
        @user = Factory(:user)
    		@attr = { :provider => "facebook", :uid => "1234" }

    		@authentication = @user.authentications.build(@attr)

      end

			it "should login the user for a valid credential of an existing user" do
			  OmniAuth.config.add_mock(:facebook, {:uid => '1234'})
				get :create, :provider => 'facebook'
				
				controller.current_user.should == @user
        controller.should be_signed_in
        
		  end

			it "should redirect to create a new user for a valid credential of a non-existing user" do
				OmniAuth.config.add_mock(:facebook, {:uid => '1234'})
				get :create
			end

			it "should give an error for an invalid credential" do
				pending "post to login with an invalid credential"
				OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
			end

			it "should login automatically a user with a Facebook signed_request"

		end
  
		describe "for signed-in users" do

			it "should create a new authentication for a valid credential"

			it "should not create a duplicate authentication"

			it "should give an error for an invalid credential"

			it "should login automatically a user with a Facebook signed_request"

		end

	end
	
	describe "GET 'destroy'" do

		it "should remove an existing authentication"

	end
		
end
