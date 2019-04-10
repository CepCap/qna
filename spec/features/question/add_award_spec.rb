require 'rails_helper'

feature 'User can add awards to question', %q{
  In order to award most helpfull answer
  As an author of question
  I'd like to be able to give user award
} do

  given(:author) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User adds award when asks question' do
    sign_in(author)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'

    fill_in 'Award name', with: 'Award!'
    attach_file 'File', "#{Rails.root}/storage/level1_bg.jpg"

    click_on 'Ask'

    expect(page).to have_content 'Award available!'
  end
end
