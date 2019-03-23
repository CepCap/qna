require 'rails_helper'

feature 'User can create answer for a question', %q{
  In order to answer a question
  As an authenticated User
  I'd like to be able to post an answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Answers a question' do
      fill_in 'Body', with: 'test test test'
      click_on 'Answer'

      expect(page).to have_content 'test test test'
    end

    scenario 'Answers a question with invalid answer' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
