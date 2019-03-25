require 'rails_helper'

feature 'User can pick best answer', %q{
  In order to choose best answer
  As an author of a question
  I'd like to be able to pick best answer
} do

  given!(:user)         { create(:user) }
  given!(:author_user)  { create(:user) }
  given!(:question)     { create(:question, author: author_user) }
  given!(:answer_list)  { create_list(:answer, 3, question: question) }
  given!(:answer)       { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user does not see "pick best" link' do
    visit question_path(question)

    expect(page).to_not have_content "Pick as best"
  end

  describe 'Authenticated user, ', js: true do
    describe 'Author, ' do
      before do
        sign_in(author_user)
      end

      describe 'picks best answer' do
        scenario 'with no present best answer' do
          visit question_path(question)

          within "div.answer-id-#{answer.id}" do
            click_on 'Pick as best'
          end

          expect(page).to have_content "#{answer.body} - best answer"
        end

        scenario 'with present best answer' do
          best_answer = create(:answer, body: 'previous best', question: question,
                                author: author_user, best: true)

          visit question_path(question)

          within "div.answer-id-#{answer.id}" do
            click_on 'Pick as best'
          end

          expect(page).to_not have_content "previous best - best answer"
          expect(page).to have_content "#{answer.body} - best answer"
        end
      end
    end

    describe 'Non-author, ' do
      scenario 'does not see "pick best" link' do
        expect(page).to_not have_content "Pick as best"
      end
    end
  end

end
