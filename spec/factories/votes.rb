FactoryBot.define do
  factory :vote do
    vote_type { 1 }
    user
    association :voteable, factory: :answer
  end
end
