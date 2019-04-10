require 'rails_helper'

feature 'User can view his awards', %q{
  In order to check my awards
  As a user
  I'd like to be able to lookup my awards
} do

  given(:awarded_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:award) { create(:award, question: question, user: awarded_user) }

  background do
    award.image.attach(io: File.open("#{Rails.root}/storage/level1_bg.jpg"), filename: 'level1_bg.jpg')
  end

  scenario 'Awarded user wants to see his awards' do
    sign_in(awarded_user)
    visit awards_path

    expect(page).to have_content award.name
    expect(page).to have_content award.question.title
    expect(page).to have_css("img[src*='level1_bg.jpg']")
  end
end
