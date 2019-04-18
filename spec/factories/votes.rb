FactoryBot.define do
  factory :vote do
    vote_type { true }
    user
    association :voteable, factory: :answer
  end
end
