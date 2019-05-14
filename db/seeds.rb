# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = Rails.application.credentials[:development][:admin]

user = Rails.application.credentials[:development][:user]

User.create(email: admin[:email], admin: true, password: admin[:password],
            password_confirmation: admin[:password], confirmed_at: DateTime.now)

User.create(email: user[:email], password: user[:password],
            password_confirmation: user[:password], confirmed_at: DateTime.now)

5.times do |i|
  question = Question.create(title: "#{i}. question:", body: "How to #{i}",
                             author: [User.first, User.second].sample)
  3.times do |e|
    Answer.create(body: "#{e} answer", question: question,
                  author: [User.first, User.second].sample)
  end
end
