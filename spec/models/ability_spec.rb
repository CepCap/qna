require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:user_question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, :all }

    it { should_not be_able_to :create, Award }
    it { should_not be_able_to :update, Award }
    it { should_not be_able_to :destroy, Award }

    it { should be_able_to :update, create(:question, author: user), user: user }
    it { should_not be_able_to :update, create(:question, author: other), user: user }

    it { should be_able_to :destroy, create(:question, author: user), user: user }
    it { should_not be_able_to :destroy, create(:question, author: other), user: user }

    it { should be_able_to :update, create(:answer, author: user), user: user }
    it { should_not be_able_to :update, create(:answer, author: other), user: user }

    it { should be_able_to :destroy, create(:answer, author: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, author: other), user: user }

    it { should be_able_to :update, create(:comment, user: user), user: user }
    it { should_not be_able_to :update, create(:comment, user: other), user: user }

    it { should be_able_to :destroy, create(:link, linkable: user_question), author: user }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question), author: user }

    it { should be_able_to :pick_best, create(:answer, author: other), user: user}
    it { should_not be_able_to :pick_best, create(:answer, author: user), user: user}

  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
  end
end
