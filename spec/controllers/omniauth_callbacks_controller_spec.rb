require 'rails_helper'
RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #facebook' do
    context 'no oauth' do
      before do
        get :facebook
      end

      it 'should redirect_to new user registration' do
        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'user does not exist' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new-user@email.com' })
        get :facebook
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
      it { should be_user_signed_in }
    end
  end

  describe 'GET #twitter' do
    context 'email is nil' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: nil })
        get :twitter
      end

      it 'stores data in session' do
        expect(session['provider']).to eq 'twitter'
        expect(session['uid']).to eq '123456'
      end

      it { should_not be_user_signed_in }
      it { expect(response).to render_template :confirm_email }
    end

    context 'user does not exist' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: 'new-user@email.com' })
        get :twitter
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
    end

    context 'everything is nil' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: nil, uid: nil, info: { email: nil })
        get :twitter
      end

      it 'redirect to registration' do
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
end
