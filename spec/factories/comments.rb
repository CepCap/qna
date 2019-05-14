FactoryBot.define do
  factory :comment do
    body { 'MyComment' }
    user
    association :commentable, factory: :answer
  end
end
