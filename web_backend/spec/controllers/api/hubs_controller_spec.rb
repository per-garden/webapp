require 'spec_helper'

describe Api::HubsController, :type => :controller do 
  describe 'hub(s) read and update' do

    before :all do
      @hubs = create_list(:hub, 5)
      @session = create(:logged_in_session)
    end

    it 'gets index list if valid session' do
      params = {api_token: @session.api_token}
      get :index, params: params
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq 5
    end

    it 'gets hub details if valid id and session' do
      hub = @hubs.sample(1).first
      params = {api_token: @session.api_token, id: hub.id}
      get :show, params: params
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_content(hub.name)
    end

    it 'gets nothing if empty token' do
      get :index
      expect(response).to have_http_status(422)
    end

    it 'gets nothing if invalid non-empty token' do
      params = {api_token: 'wspijg08ih00417pj20p'}
      get :index, params: params
      expect(response).to have_http_status(401)
    end

    after :all do
      @hubs.each {|h| h.destroy}
      # Clearing a session would obviously not normally delete the user...
      @session.user.destroy
      @session.destroy
    end
  end
end
