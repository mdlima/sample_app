require 'spec_helper'

describe FollowshipsController do

  describe "access control" do

    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
    end

    it "should create a followship" do
      lambda do
        post :create, :followship => { :followed_id => @followed }
        response.should be_redirect
      end.should change(Followship, :count).by(1)
    end
    
    it "should create a relationship using Ajax" do
      lambda do
        xhr :post, :create, :followship => { :followed_id => @followed }
        response.should be_success
      end.should change(Followship, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      @user.follow!(@followed)
      @followship = @user.followships.find_by_followed_id(@followed)
    end

    it "should destroy a followship" do
      lambda do
        delete :destroy, :id => @followship
        response.should be_redirect
      end.should change(Followship, :count).by(-1)
    end
    
    it "should destroy a relationship using Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @followship
        response.should be_success
      end.should change(Followship, :count).by(-1)
    end
  end
end