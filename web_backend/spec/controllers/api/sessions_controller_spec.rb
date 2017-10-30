require 'spec_helper'

describe Api::SessionsController, :type => :controller do 
  describe 'login' do

    before :all do
      @session = create(:logged_in_session)
    end

    it 'lets user log out' do
      token = @session.api_token
      params = {api_token: token}
      get :logout, params: params
      expect(response).to have_http_status(200)
      expect(Api::Session.find_by_api_token(token)).to be_nil
    end

    after :all do
      @session.destroy
    end

  end
end
