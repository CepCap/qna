require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create', js: true do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:comment_params) { { comment: { body: 'Hello' }, commentable_type: 'Question', commentable_id: "#{question.id}" } }

    scenario 'unauthenticated user cant vote' do
      expect { post :create, params: comment_params, format: :js }.to_not change(Comment, :count)
    end

    context 'authenticated user' do
      before { login(user) }

      scenario 'comments' do
        expect { post :create, params: comment_params, format: :js }.to change(Comment, :count).by(1)
      end
    end
  end
end
