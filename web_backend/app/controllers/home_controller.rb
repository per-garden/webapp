class HomeController < ApplicationController
  # before_action :authenticate_user!
  before_action :require_login

  def index
    # TODO: Token rewrite between calls
  end

  private

  def require_login
    @token = request.headers[:QUERY_STRING].split('=')[1] || request.headers[:HTTP_API_TOKEN] || params[:api_token]
    puts @token
    if @token.blank? || !Api::Session.find_by_api_token(@token)
      redirect_to login_path
    end
  end
end
