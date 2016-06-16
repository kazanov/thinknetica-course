class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :process_callback

  def facebook
  end

  def twitter
  end

  def confirm_email
  end

  private

  def process_callback
    @auth_hash = request.env['omniauth.auth'] || session_oauth
    @user = User.find_for_oauth(@auth_hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: @auth_hash.provider.capitalize if is_navigational_format?
    elsif @auth_hash.provider
      session['provider'] = @auth_hash.provider
      session['uid'] = @auth_hash.uid
      render 'omniauth_callbacks/confirm_email'
    else
      show_failure
    end
  end

  def session_oauth
    OmniAuth::AuthHash.new(provider: session['provider'], uid: session['uid'], info: { email: params[:email] })
  end

  def show_failure
    redirect_to new_user_registration_path, flash: { notice: 'Could not authenticate you because of invalid credentials' }
  end
end
