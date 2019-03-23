require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe '#is_best?' do
    let(:answer) { create(:answer) }
    let(:best_answer) { create(:answer, best: true) }

    it 'shows if answer is best' do
      expect(answer).to_not be_is_best
      expect(best_answer).to be_is_best
    end
  end
end
