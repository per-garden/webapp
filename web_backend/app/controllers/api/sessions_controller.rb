module Api
  class SessionsController < ActionController::API
    before_action :require_login, :except => :login

    respond_to :json

    def login
      login = params[:login] || request.headers[:HTTP_LOGIN]
      password = params[:password] || request.headers[:HTTP_PASSWORD]
      if login.blank? || password.blank?
        render json: {success: false, message: 'Missing login credentials'}, status: 422
      else
        resource = User.find_for_database_authentication(email: login) || User.find_for_database_authentication(name: login)
        if resource && resource.valid_password?(password)
          user = sign_in('user', resource)
          token = SecureRandom.hex
          api_session = Api::Session.new(user: user, api_token: token)
          api_session.save!
          render json: {success: true, api_token: token}
        else
          warden.custom_failure!
          render json: {success: false, message: 'Incorrect login credentials'}, status: 401
        end
      end
    end

    def logout
      session = Api::Session.find_by_api_token(@token)
      sign_out session.user
      session.destroy
      render json: {success: true, message: "Logged out"}
    end

    private

    def require_login
      @token = request.headers[:QUERY_STRING].split('=')[1] || request.headers[:HTTP_API_TOKEN]
      if @token.blank?
        render json: {success: false, message: 'Not logged in.'}, status: 422
      else
        render json: {success: false, message: 'Invalid api token.'}, status: 401 unless Api::Session.find_by_api_token(@token)
      end
    end

  end
end
