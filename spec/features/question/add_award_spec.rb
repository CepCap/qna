require 'rails_helper'

feature 'User can add awards to question', %q{
  In order to award most helpfull answer
  As an author of question
  I'd like to be able to give user award
} do

  given!(:author) { create(:user) }
  given!(:awarded_user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:award) { create(:award, name: 'Award name', question: question) }
  given!(:answer) { create(:answer, question: question, author: awarded_user) }

  scenario 'User adds award when asks question' do
    sign_in(author)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'

    fill_in 'Award name', with: 'Award!'
    attach_file 'File', "#{Rails.root}/storage/bg.jpg"

    click_on 'Ask'

    expect(page).to have_content 'Award available!'
  end

  scenario 'Author of question picks best answer and answers author gets an award', js: true do
    award.image.attach(io: File.open("#{Rails.root}/storage/bg.jpg"), filename: 'bg.jpg')

    sign_in(author)
    visit question_path(question)

    within "[data-answer-id='#{answer.id}']" do
      click_on 'Pick as best'
    end


    click_on 'Sign out'
    sign_in(awarded_user)
    visit awards_path

    expect(page).to have_content 'Award name'
  end
end
