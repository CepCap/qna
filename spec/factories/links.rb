FactoryBot.define do
  factory :link do
    name { 'MyLink' }
    url { 'https://gist.github.com/CepCap/a838c02b1ede090976fe0b4956deb9fd' }
    association :linkable, factory: :question
  end
end
