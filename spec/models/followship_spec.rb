require 'spec_helper'

describe Followship do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))

    @followship = @follower.followships.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @followship.save!
  end
  
  describe "follow methods" do

    before(:each) do
      @followship.save
    end

    it "should have a follower attribute" do
      @followship.should respond_to(:follower)
    end

    it "should have the right follower" do
      @followship.follower.should == @follower
    end

    it "should have a followed attribute" do
      @followship.should respond_to(:followed)
    end

    it "should have the right followed user" do
      @followship.followed.should == @followed
    end
  end
  
  describe "validations" do

    it "should require a follower_id" do
      @followship.follower_id = nil
      @followship.should_not be_valid
    end

    it "should require a followed_id" do
      @followship.followed_id = nil
      @followship.should_not be_valid
    end
  end
end