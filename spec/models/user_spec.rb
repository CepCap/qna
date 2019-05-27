require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

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

  describe '#subscribe' do
      let(:user) { create(:user) }
      let!(:question) { create(:question) }

      it 'creates new subscription' do
        expect { user.subscribe(question) }.to change(Subscription, :count).by(1)
      end

      context 'user already has subscription' do
        it 'does not create new subscription' do
          user.subscribe(question)
          expect { user.subscribe(question) }.to_not change(Subscription, :count)
        end
      end
    end

    describe '#subscribed?' do
      let(:user) { create(:user) }
      let(:question) { create(:question) }

      it 'should return true if user is subscribed to the question' do
        user.subscribe(question)
        expect(user).to be_subscribed(question)
      end

      it 'should return false if user is not subscribed to the question' do
        expect(user).to_not be_subscribed(question)
      end
    end

    describe '#unsubscribe' do
      let(:user) { create(:user) }
      let!(:question) { create(:question) }

      it 'deletes subscription from the database' do
        user.subscribe(question)
        expect { user.unsubscribe(question) }.to change(Subscription, :count).by(-1)
      end

      context 'user doesnt have a subscription' do
        it 'does not create new subscription' do
          expect { user.unsubscribe(question) }.to_not change(Subscription, :count)
        end
      end
  end
end
