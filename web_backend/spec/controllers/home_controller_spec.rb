require 'spec_helper'

describe HomeController, :type => :controller do 
  describe "GET" do

    before :all do
      @user = create(:user)
    end

    it 'requires user to log in' do
      get :index
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'lets user log in' do
      sign_in @user
      get :index
      expect(response).to render_template('home/index')
    end

    after :all do
      @user.destroy
    end
  end
end
