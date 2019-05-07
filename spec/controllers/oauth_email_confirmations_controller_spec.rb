require 'rails_helper'

RSpec.describe OauthEmailConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'renders :new' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'test@test.com' }) }

    context 'user exists' do
      let!(:user) { create(:user) }
      let(:auth_params) { { provider: 'github', uid: '123456', email: user.email } }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
      end

      it 'redirects to login' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user doesnt exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        post :create
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end

      it 'doesnt login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
