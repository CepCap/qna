require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info for an answer
  As an author of answer
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:google_url) { 'https://google.com' }
  given(:github_url) { 'https://github.com' }
  given(:gist_url) { 'https://gist.github.com/CepCap/a838c02b1ede090976fe0b4956deb9fd' }

  describe 'User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds link to gist when answers', js: true do
      fill_in 'Body', with: 'Test body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'

      visit question_path(question)
      expect(page).to have_css '.gist-file'
    end

    scenario 'adds link when answers', js: true do
      fill_in 'Body', with: 'Test body'

      fill_in 'Link name', with: 'Github'
      fill_in 'Url', with: github_url

      click_on 'Answer'

      expect(page).to have_link('Github', href: github_url)
    end

    scenario 'adds multiple links when answers', js: true do
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

      click_on 'Answer'

      expect(page).to have_link('Github', href: github_url)
      expect(page).to have_link('Google', href: google_url)
    end
  end
end
