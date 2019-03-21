FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :random_title do
      title { ('a'..'z').to_a.shuffle.join }
    end
  end
end
