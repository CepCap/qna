FactoryBot.define do
  factory :answer do
    body { ('a'..'z').to_a.shuffle.join }
    question

    trait :invalid do
      body { nil }
    end
  end
end
