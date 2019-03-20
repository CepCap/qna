require 'rails_helper'

feature 'User can look up created questions', %q{
  In order to look up questions from a community
  As an authenticated User or a guest
  I'd like to be able to view all questions
} do

  describe 'View all questions' do
    given!(:questions) { create_list(:question, 3) }

    background { visit questions_path }

    scenario 'have a list of all questions' do
      questions.each do |question|
        expect(page).to have_content(question.title && question.body)
      end
    end

    scenario 'have a link to each question' do
      questions.each do |question|
        expect(page).to have_link question.title, href: question_path(question)
      end
    end
  end
end
