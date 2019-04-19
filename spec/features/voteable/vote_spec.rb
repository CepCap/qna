require 'rails_helper'

feature 'User can vote', %q{
  In order to show how helpfull an answer or a question is
  As a user
  I'd like to be able to vote
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given(:answer) { create(:answer, question: question) }

  describe 'unauthenticated user' do
    scenario 'doesnt see vote links' do
      visit question_path(question)

      expect(page).to_not have_content 'Upvote'
      expect(page).to_not have_content 'Downvote'
    end
  end

  describe 'author user' do
    scenario 'doesnt see vote links' do
      sign_in(author)
      visit question_path(question)

      expect(page).to_not have_content 'Upvote'
      expect(page).to_not have_content 'Downvote'
    end
  end

  describe 'user', js: true do
    background do
      sign_in(user)
      answer
      visit question_path(question)
    end

    describe 'havent voted yet' do
      scenario 'votes for the first time' do
        within '.answer' do
          click_on 'Upvote'

          within '.vote-result' do
            expect(page).to have_content '1'
          end
        end
      end
    end

    describe 'already voted' do
      given!(:vote) { create(:vote, user: user, voteable: answer) }

      scenario 'votes the same' do

        within '.answer' do
          click_on 'Upvote'

          within '.vote-result' do
            expect(page).to have_content '0'
          end
        end
      end

      scenario 'votes differently' do
        within '.answer' do
          click_on 'Downvote'

          within '.vote-result' do
            expect(page).to have_content '-1'
          end
        end
      end
    end
  end
end
