require 'rails_helper'

feature 'User can create comments', %q{
  In order to get discuss current subject
  As an authenticated User
  I'd like to be able to comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

    scenario 'sends a comment' do
      fill_in 'Comment', with: 'test test test'
      click_on 'Send'

      expect(page).to have_content 'test test test'
    end

    scenario 'Sends a comment with errors' do
      click_on 'Send'

      expect(page).to have_content "can't be blank"
    end
  end

  describe 'multiple sessions' do
    scenario 'comment appears on another users page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment', with: 'test test test'
        click_on 'Send'

        expect(page).to have_content 'test test test'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test test test'
      end
    end
  end
end
