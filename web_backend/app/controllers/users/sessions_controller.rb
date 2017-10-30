class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    login = params[:user] ? params[:user][:login] : nil
    login ||= request.headers[:HTTP_LOGIN]
    password = params[:user] ? params[:user][:password] : nil
    password ||= request.headers[:HTTP_PASSWORD]
    if login.blank? || password.blank?
      redirect_to root_path, notice: 'Missing login credentials'
    else
      resource = User.find_for_database_authentication(email: login) || User.find_for_database_authentication(name: login)
      if resource && resource.valid_password?(password)
        user = sign_in('user', resource)
        @token = SecureRandom.hex
        api_session = Api::Session.new(user: user, api_token: @token)
        api_session.save!
        redirect_to root_path(api_token: @token)
      else
        warden.custom_failure!
        redirect_to root_path, notice: 'Incorrect login credentials'
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
