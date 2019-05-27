require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      it 'creates new subscription in the database' do
        expect { post :create, params: { id: question } }.to change(Subscription, :count).by(1)
      end

      context 'already subscribed' do
        before do
          login(user)
          user.subscribe(question)
        end

        it 'does not create new subscription in the database' do
          expect { post :create, params: { id: question } }.to_not change(Subscription, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not create new subscription in the database' do
        expect { post :create, params: { id: question } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'Authenticated user' do
      before do
        login(user)
        user.subscribe(question)
      end

      it 'deletes current subscription from the database' do
        expect { delete :destroy, params: { id: question } }.to change(Subscription, :count).by(-1)
      end
    end

    context 'Authenticated user, with no subscription' do
      before { login(user) }

      it 'does not delete subscription' do
        expect { delete :destroy, params: { id: question } }.to_not change(Subscription, :count)
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete subscription' do
        expect { delete :destroy, params: { id: question } }.to_not change(Subscription, :count)
      end
    end
  end
end
