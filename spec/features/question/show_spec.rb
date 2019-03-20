require 'rails_helper'

feature 'User or a guest can view answers for a question', %q{
  In order to view answers for a question
  As an authenticated User or a guest
  I'd like to be able to get answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, :random_body, question: question) }

  scenario 'Visits question' do
    visit question_path(question)
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
