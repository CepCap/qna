require 'rails_helper'

feature 'Author can delete created questions', %q{
  In order remove a question
  As an author
  I'd like to be able to delete a question
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Author' do

    scenario 'presses delete' do
      sign_in(author)
      visit questions_path
      expect(page).to have_link question.title
      visit question_path(question)

      click_on 'Delete question'
      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_link question.title
    end
  end

  describe 'Non-author user wants to delete question' do
    scenario 'doesnt see delete link' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end
end
