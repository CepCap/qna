require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  describe '#choose_best' do
    let!(:question) { create(:question) }
    let!(:previous_best) { create(:answer, best: true, question: question) }
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:award) { create(:award, question: question) }

    describe 'choosing best answer' do
      before { answer.choose_best }

      it 'should make previous best answer attribute "best" false' do
        previous_best.reload
        expect(previous_best).to_not be_best
      end

      it 'should make new best answer attribute "best" true' do
        answer.reload
        expect(answer).to be_best
      end
    end

    it 'should give award to author of answer' do
      expect { answer.choose_best }.to change(user.awards, :count).by(1)
    end
  end

  describe '#email_subscribers' do
    it 'calls SubscriptionJob#perform_later' do
      question = create(:question)
      user = create(:user)
      user.subscribe(question)

      answer = build(:answer, question: question, user: user)

      expect(SubscriptionJob).to receive(:perform_later).with(question)
      answer.save
    end
  end
end
