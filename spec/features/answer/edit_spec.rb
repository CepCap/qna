require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of an answer
  I'd like to be able to edit my answer
} do

  given!(:user)         { create(:user) }
  given!(:author_user)  { create(:user) }
  given!(:question)     { create(:question) }
  given!(:answer)       { create(:answer, question: question, author: author_user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  describe 'Authenticated user', js: true do

    describe 'Author user' do
      background do
        sign_in(author_user)
        visit question_path(question)
      end

      scenario 'edits his answer', js: true do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Body', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits answer with attached files' do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Body', with: 'edited answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors' do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Body', with: ''
          click_on 'Save'
        end
        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'Non-author user' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to edit other users question' do
        expect(page).to_not have_content 'Edit'
      end
    end
  end
end
