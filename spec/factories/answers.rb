FactoryBot.define do
  factory :answer do
    body { "MyText" }
    best { false }
    question
    association :user, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :random_body do
      body { ('a'..'z').to_a.shuffle.join }
    end
  end
end
