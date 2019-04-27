FactoryBot.define do
  factory :comment do
    body { 'MyComment' }
    user
    association :voteable, factory: :answer
  end
end
