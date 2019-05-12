require 'rails_helper'

feature 'Guest can sign up', %q{
  In order to ask question,
  As a guest,
  I'd like to sign up.
} do

  describe 'Guest clicks on sign up' do

    background { visit new_user_registration_path }

    scenario 'fills forms with valid data' do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      open_email('new_user@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'fills forms with invalid data' do
      click_on 'Sign up'

      expect(page).to have_content('errors prohibited this' || 'error prohibited this')
    end
  end

end
