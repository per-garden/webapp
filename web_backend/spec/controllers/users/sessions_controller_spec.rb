require 'spec_helper'

describe Users::SessionsController, :type => :controller do 
  describe 'login' do

    before :each do
      @user = create(:user)
      wtf = {}
      wtf["devise.mapping"] = Devise.mappings[:user]
      @request.env.merge!(wtf)
    end

    it 'requires credentials login and password' do
      params = {foo: 'bar'}
      post :create, params: params
      session = Api::Session.find_by_user_id(@user.id)
      expect(session).to be_nil
    end

    it 'lets user log in by email' do
      params = {user: {login: @user.email, password: @user.password}}
      post :create, params: params
      session = Api::Session.find_by_user_id(@user.id)
      expect(session).not_to be_nil
    end

    it 'lets user log in by name' do
      params = {user: {login: @user.name, password: @user.password}}
      post :create, params: params
      session = Api::Session.find_by_user_id(@user.id)
      expect(session).not_to be_nil
    end

    after :each do
      @user.destroy
    end

  end
end
