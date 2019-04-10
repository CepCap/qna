require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  describe '#choose_best' do
    let!(:question) { create(:question) }
    let!(:previous_best) { create(:answer, best: true, question: question) }
    let!(:answer) { create(:answer, question: question) }

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
end
