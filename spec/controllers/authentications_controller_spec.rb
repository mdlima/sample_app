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
				@authentication = Factory(:authentication)
				@user = @authentication.user
			end

			it "should login the user for a valid credential of an existing user" do
				@request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "1234" }
				get :create #, :provider => 'facebook'
				controller.current_user.should == @user
				controller.should be_signed_in
			end

			it "should redirect to create a new user for a valid credential of a non-existing user" do
				@request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "1111" }
				get :create
				controller.should redirect_to (signup_path)
			end

			it "should redirect to signup for an invalid credential" do
				@request.env['omniauth.auth'] = {}
				get :create
				controller.should redirect_to (signup_path)				
			end

			it "should login automatically a user with a Facebook signed_request"

		end
	
		describe "for signed-in users" do
			
			before(:each) do
				@user = Factory(:user)
				@attr = { "provider" => "facebook", "uid" => "1234" }
				test_sign_in @user
			end

			it "should create a new authentication for a valid credential" do
				lambda do
					@request.env['omniauth.auth'] = @attr
					get :create #, :provider => 'facebook'
				end.should change(Authentication, :count).by(1)
			end

			it "should give an error message" do
				@request.env['omniauth.auth'] = {}
				get :create
				flash[:notice].should =~ /invalid/i
			end

			it "should not create a duplicate authentication" do
				lambda do
					@request.env['omniauth.auth'] = @attr
					get :create #, :provider => 'facebook'
				end.should change(Authentication, :count).by(1)
			end

			it "should login automatically a user with a Facebook signed_request"

		end

	end
	
	describe "GET 'destroy'" do

		describe "for an unauthorized user" do

			before(:each) do
				@user = Factory(:user)
				@authentication = Factory(:authentication, :user => @user)
				wrong_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
				test_sign_in(wrong_user)
			end

			it "should deny access" do
			  delete :destroy, :id => @authentication
			  response.should redirect_to(root_path)
			end
		end


		describe "for an authorized user" do

			before(:each) do
				@authentication = Factory(:authentication)
				@user = @authentication.user
				test_sign_in @user
			end

			it "should remove the authentication" do
				lambda do			
					get :destroy, :id => @authentication
				end.should change(Authentication, :count).by(-1)	
			end
		end

		describe "for an admin user" do

			before(:each) do
				@authentication = Factory(:authentication)
				@user = @authentication.user
				wrong_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email), :admin => true)
				test_sign_in(wrong_user)
			end

			it "should remove the authentication" do
				lambda do			
					get :destroy, :id => @authentication
				end.should change(Authentication, :count).by(-1)	
			end
		end

	end
		
end
