require 'spec_helper'

describe FbIntegrationsController do

  describe "GET 'login'" do
    it "should be successful" do
      get 'login'
      response.should be_success
    end
  end

end
