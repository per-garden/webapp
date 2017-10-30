class HomeController < ApplicationController
  # before_action :authenticate_user!
  before_action :require_login, skip: :precache

  def index
    # TODO: Token rewrite between calls
  end

  def precache
    # TODO: How to handle Google's _sw-precache?
    redirect_to root_path, status: 501
  end

  private

  def require_login
    @token = request.headers[:QUERY_STRING].split('=')[1] || request.headers[:HTTP_API_TOKEN] || params[:api_token]
    params[:api_token] = nil unless Api::Session.find_by_api_token(@token)
    if @token.blank? # || !Api::Session.find_by_api_token(@token)
      redirect_to new_user_session_path #login_path
    end
  end
end
