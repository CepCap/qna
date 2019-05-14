FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    admin { false }
    password { '12345678' }
    password_confirmation { '12345678' }
    after :create do |user|
      user.confirm
    end
  end
end
