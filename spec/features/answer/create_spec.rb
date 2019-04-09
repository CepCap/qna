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

    scenario 'answers a question with attached files' do
      fill_in 'Body', with: 'test test test'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
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
