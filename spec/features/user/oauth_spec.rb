require 'rails_helper'

feature 'User can authenticate via oauth providers', %q{
  In order to login/sign up
  As a User or guest
  Id like to be able to authenticate through social media
} do

  scenario 'User authenticates through his social media' do
    create(:user, email: 'user@email.com', confirmed_at: DateTime.now)
    visit new_user_session_path

    github_mock
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from github account.'
    expect(page).to have_link 'Sign out'
  end

  context 'Oauth provider with no email' do
    scenario 'User tries to authenticate' do
      create(:user, email: 'test@email.com', confirmed_at: DateTime.now)
      visit new_user_session_path

      vk_mock
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please enter your email for confirmation'
      expect(page).to_not have_link 'Sign out'

      fill_in 'Email', with: 'test@email.com'
      click_on 'Send email'

      expect(page).to have_content 'Your account has been linked to social media!'
      expect(page).to have_link 'Sign out'
    end

    scenario 'Guest tries to authenticate' do
      visit new_user_session_path

      vk_mock
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please enter your email for confirmation'
      expect(page).to_not have_link 'Sign out'

      fill_in 'Email', with: 'test@email.com'
      click_on 'Send email'

      open_email('test@email.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
      expect(page).to_not have_link 'Sign out'

      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
      expect(page).to have_link 'Sign out'
    end
  end

  scenario 'User tries to authenticate with incorrect data' do
    invalid_mock
    visit new_user_session_path

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid".'
    expect(page).to_not have_link 'Sign out'
  end
end
