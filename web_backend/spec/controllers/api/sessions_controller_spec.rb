require 'spec_helper'

describe Api::SessionsController, :type => :controller do 
  describe 'login' do

    before :all do
      @user = create(:user)
    end

    it 'requires non-empty login credentials' do
      post :login
      expect(response).to have_http_status(422)
    end

    it 'requires credentials login and password' do
      params = {foo: 'bar'}
      post :login, params: params
      expect(response).to have_http_status(422)
    end

    it 'lets user log in by email' do
      params = {login: @user.email, password: @user.password}
      post :login, params: params
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['api_token']).not_to be_empty
    end

    it 'lets user log in by name' do
      params = {login: @user.name, password: @user.password}
      post :login, params: params
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['api_token']).not_to be_empty
    end

    it 'lets user log out' do
      token = Api::Session.find_by_user_id(@user.id).api_token
      params = {api_token: token}
      get :logout, params: params
      expect(response).to have_http_status(200)
      expect(Api::Session.find_by_api_token(token)).to be_nil
    end

    after :all do
      @user.destroy
    end

  end
end
