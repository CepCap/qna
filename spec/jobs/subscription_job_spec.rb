require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:users) { create_list(:user, 3) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  before do
    users.each do |user|
      user.subscribe(question)
    end
  end

  it 'sends notifications to subscribed users' do
    expect(SubscriptionMailer).to receive(:subscription).with(question, author).and_call_original

    users.each do |user|
      expect(SubscriptionMailer).to receive(:subscription).with(question, user).and_call_original
    end

    SubscriptionJob.perform_now(question)
  end
end
