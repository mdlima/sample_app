require 'spec_helper'

describe Authentication do
  before(:each) do
    @user = Factory(:user)
		@attr = { :provider => "aaaa", :uid => "1111" }
		
		@authentication = @user.authentications.build(@attr)
    
  end  

	it "should create a new instance given valid attributes" do
		@authentication.save!
	end
  
  describe "user associations" do

		before(:each) do
			@authentication.save
		end

		it "should have a user attribute" do
			@authentication.should respond_to(:user)
		end

		it "should have the right associated user" do
			@authentication.user_id.should == @user.id
			@authentication.user.should == @user
		end
	end
	
	describe "validations" do

#    it "should require a user id" do
#      @authentication.user_id = nil
#      @authentication.should_not be_valid
#    end

    it "should require a valid provider" do
      @authentication.provider = nil
      @authentication.should_not be_valid
    end

    it "should require a nonempty uid" do
      @authentication.uid = nil
      @authentication.should_not be_valid
    end

    it "should reject duplicate providers" do
      @authentication.save!
      @auth2 = @user.authentications.build(@attr)
      @auth2.save
      @auth2.should_not be_valid
    end
  end

end
