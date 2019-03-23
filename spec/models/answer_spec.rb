require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe '#choose_best' do
    let(:previous_best) { create(:answer, best: true) }
    let(:answer) { create(:answer) }

    it 'should make previous best answer attribute "best" false' do
      expect { Answer.choose_best(previous_best, answer) }.to change(previous_best, :best).from(true).to(false)
    end

    it 'should make new best answer attribute "best" true' do
      expect { Answer.choose_best(previous_best, answer) }.to change(answer, :best).from(false).to(true)
    end
  end
end
