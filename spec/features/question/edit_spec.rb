require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of a questiopn
  I'd like to be able to edit my question
} do

  given!(:user)         { create(:user) }
  given!(:author)       { create(:user) }
  given!(:question)     { create(:question, author: author) }

  describe 'Authenticated author user' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edits a question' do
      click_on 'Edit question'

      fill_in 'Title', with: 'edited question'
      fill_in 'Body', with: 'edited body'
      click_on 'Save'

      expect(page).to have_content('edited question')
      expect(page).to have_content('edited body')
    end

    scenario 'edits a question with files' do
      click_on 'Edit question'

      fill_in 'Title', with: 'edited question'
      fill_in 'Body', with: 'edited body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_content('edited question')
      expect(page).to have_content('edited body')
      expect(page).to have_link('spec_helper.rb')
      expect(page).to have_link('rails_helper.rb')
    end
  end

  describe 'Non-author user' do
    scenario 'Doesnt see an edit link' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Doesnt see an edit link' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end

end
