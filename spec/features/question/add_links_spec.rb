require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info for a question
  As an author of question
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://google.com' }
  given(:github_url) { 'https://github.com' }
  given(:gist_url) { 'https://gist.github.com/CepCap/a838c02b1ede090976fe0b4956deb9fd' }

  describe 'user' do
    before do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User adds link to gist', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_css '.gist-file'
    end

    scenario 'User adds link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      fill_in 'Link name', with: 'Github'
      fill_in 'Url', with: github_url

      click_on 'Ask'
      expect(page).to have_link('Github', href: github_url)
    end

    scenario 'User adds multiple links when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      click_on 'add link'

      within all('.nested-fields')[0] do
        fill_in 'Link name', with: 'Github'
        fill_in 'Url', with: github_url
      end

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Ask'

      expect(page).to have_link('Github', href: github_url)
      expect(page).to have_link('Google', href: google_url)
    end
  end

end
