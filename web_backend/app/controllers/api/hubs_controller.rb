module Api
  class HubsController < ActionController::API
    before_action :require_login

    respond_to :json

    def index
      render json: Hub.all
    end

    def show
      begin
        render json: Hub.find(params[:id])
      rescue
        render json: {success: false, message: 'Invalid hub id.'}, status: 401
      end
    end

    private

    def require_login
      token = request.headers[:QUERY_STRING].split('=')[1] || request.headers[:HTTP_API_TOKEN]
      if token.blank?
        render json: {success: false, message: 'Not logged in.'}, status: 422
      else
        render json: {success: false, message: 'Invalid api token.'}, status: 401 unless Api::Session.find_by_api_token(token)
      end
    end

  end
end
