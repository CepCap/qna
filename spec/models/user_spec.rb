require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it "should test if a User is an author" do
      expect(user).to be_author_of(question)
    end

    it "should test if a different user is not an author" do
      user2 = create(:user)
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '.find_for_auth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
