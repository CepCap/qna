require 'rails_helper'

feature 'User or a guest can view answers for a question', %q{
  In order to view answers for a question
  As an authenticated User or a guest
  I'd like to be able to get answers
} do

  given!(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 'Visits question' do
    visit question_path(question)
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end

end
