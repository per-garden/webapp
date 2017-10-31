require 'spec_helper'

describe HomeController, :type => :controller do 

  describe "External" do
    it 'requires user to log in' do
      get :index
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  describe "Internal" do
    before :all do
      @session = create(:logged_in_session)
    end

    it 'renders internal home' do
      get :index, {params: {api_token: @session.api_token}}
      expect(response).to render_template('home/index')
    end

    after :all do
      # Not in real env. Logging out is not fatal...
      user = @session.user
      user.destroy
      @session.destroy
    end
  end
end
