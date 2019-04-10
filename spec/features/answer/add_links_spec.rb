require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info for an answer
  As an author of answer
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/CepCap/a838c02b1ede090976fe0b4956deb9fd' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    expect(page).to have_link('My gist', href: gist_url)
  end

end
