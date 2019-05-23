require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award) }

  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#subscribed_users' do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:subscribers) { create_list(:user, 3) }
    let(:user) { create(:user) }

    before do
      subscribers.each { |user| user.subscribe(question) }
    end

    it 'returns subscribed users, including author' do
      expect(question.subscribed_users.size).to eq 4
    end

    it 'does not return non-subscribed' do
      expect(question.subscribed_users).to_not include(user)
    end
  end
end
