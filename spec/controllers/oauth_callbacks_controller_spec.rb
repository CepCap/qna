require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'github' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'test@test.com' }) }

    context 'user logged in not by email' do
      let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: nil }) }

      it 'redirects to email confirmation' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        get :github
        expect(response).to redirect_to new_oauth_email_confirmation_path
      end
    end

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user doesnt exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
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
