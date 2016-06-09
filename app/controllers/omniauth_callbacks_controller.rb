class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :process_callback
  
  def facebook
  end

  def twitter
    render 'omniauth_callbacks/confirm_email'
  end

  def confirm_email
  end

  private

  def process_callback
    @auth_hash = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
    @user = User.find_for_oauth(@auth_hash)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: @auth_hash.provider.capitalize if is_navigational_format?
    end
  end
end
