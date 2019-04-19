require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create', js: true do
    let!(:user) { create(:user) }
    let!(:author) { create(:user) }
    let!(:answer) { create(:answer, id: 1, author: author) }
    let!(:vote_params) { { vote_type: '1', voteable_id: answer.id, voteable_type: 'Answer' } }

    scenario 'unauthenticated user cant vote' do
      expect { post :create, params: { vote:  vote_params }, format: :json }.to_not change(Vote, :count)
    end

    scenario 'author user cant vote' do
      login(author)
      expect { post :create, params: { vote:  vote_params }, format: :json }.to_not change(Vote, :count)
    end

    context 'authenticated user' do
      before { login(user) }

      scenario 'votes for the first time and creates new vote' do
        expect {
          post :create, params: { vote:  vote_params  }, format: :json
        }.to change(Vote.all, :count).by(1)
      end

      context 'existing vote' do
        let!(:vote) { create(:vote, voteable: answer, user: user) }

        scenario 'votes twice deletes previous vote' do
          expect {
            post :create, params: { vote:  vote_params } , format: :json
          }.to change(Vote, :count).by(-1)
        end

        scenario 'voting differently changes existing vote' do
          post :create, params: {
            vote: { vote_type: '-1', voteable_id: answer.id, voteable_type: 'Answer' }
            }, format: :json
          vote.reload
          expect(vote.vote_type).to eq -1
        end
      end
    end
  end
end
