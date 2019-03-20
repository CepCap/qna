require 'rails_helper'

feature 'Author can delete created questions', %q{
  In order remove a question
  As an author
  I'd like to be able to delete a question
} do

  describe 'Author' do
    given(:author) { create(:user) }
    given(:question) { create(:question, author: author) }

    scenario 'presses delete' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content 'Delete question'
      click_on 'Delete question'
      expect(page).to have_content 'Your question successfully deleted.'
    end
  end

  scenario 'Non-author user wants to delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
