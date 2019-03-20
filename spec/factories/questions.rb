FactoryBot.define do
  factory :question do
    title { ('a'..'z').to_a.shuffle.join }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
