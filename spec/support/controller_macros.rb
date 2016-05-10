module ControllerMacros
  def user_sign_in
    @user = create(:user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
  end
end
