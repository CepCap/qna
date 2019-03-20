require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it "should test if a User is an author of a question or an answer" do
    author = create(:user)
    user = create(:user)
    question = create(:question, author: author)
    answer = create(:answer, question: question, author: author)

    expect(author.is_author?(question)).to be_truthy
    expect(author.is_author?(answer)).to be_truthy
    expect(user.is_author?(question)).to_not be_truthy
    expect(user.is_author?(answer)).to_not be_truthy
  end
end
