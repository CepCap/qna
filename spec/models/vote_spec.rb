require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:voteable) }

  describe '#voting' do
    let!(:user) { create(:user) }
    let!(:author) { create(:user) }
    let!(:answer) { create(:answer, author: author) }

    describe 'unauthenticated user' do
      it 'doesnt create a new vote' do
        expect { answer.voting(nil, '-1') }.to_not change(Vote, :count)
      end
    end

    describe 'author user' do
      it 'doesnt create a new vote' do
        expect { answer.voting(author, '-1') }.to_not change(Vote, :count)
      end
    end

    describe 'authenticated user' do
      it 'creates new vote if vote isnt present' do
        expect { answer.voting(user, '1') }.to change(Vote, :count).by(1)
      end

      describe 'existing vote' do
        let!(:vote) { create(:vote, user: user, voteable: answer) }

        it 'changes vote_type if vote present' do
          answer.voting(user, '-1')
          vote.reload
          expect(vote.vote_type).to be(-1)
        end

        it 'deletes vote if vote_type is the same' do
          expect { answer.voting(user, vote.vote_type.to_s) }.to change(Vote, :count).by(-1)
        end
      end
    end
  end

  describe '#vote_count' do
    let!(:answer) { create(:answer) }
    let!(:upvotes) { create_list(:vote, 5, voteable: answer) }
    let!(:downvotes) { create_list(:vote, 3, voteable: answer, vote_type: -1) }
    it 'returns the difference between upvotes and downvotes' do
      expect(answer.vote_count).to eq 2
    end
  end
end
