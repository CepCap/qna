require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

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

  describe '#delete_file' do
    let(:answer) { create(:answer) }

    it 'should delete one attached file' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      expect { answer.delete_file('rails_helper.rb') }.to change(answer.files, :count).by(-1)
    end
  end

end
