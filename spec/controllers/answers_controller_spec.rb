require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, author: author, question: question) }


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do

      it 'saves new answer and assigns user as an author' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'saves the association to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(assigns(:answer).question_id).to eq question.id
      end

      # it 'redirects to question' do
      #   post :create, params: { answer: attributes_for(:answer), question_id: question }
      #   expect(response).to redirect_to question
      # end
    end

    context 'with invalid attributes' do
      it 'doesnt save a new answer in DB' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      # it 're-renders question' do
      #   post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
      #   expect(response).to render_template :create
      # end
    end
  end

  describe 'PATCH #update' do

    describe 'author updates answer' do
      before { login(author) }

      context 'with valid attributes' do
        it "changes answer attributes" do
          patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js
          answer.reload

          expect(answer.body).to eq "New body"
        end

        # it 'redirects back to question' do
        #   patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js
        #   expect(response).to redirect_to answer.question
        # end
      end

      context 'with invalid attributes'do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }

        it 'doesnt changes answer attributes' do
          answer.reload

          expect(answer.body).to eq "MyText"
        end

        # it 're-renders question' do
        #   expect(response).to render_template 'questions/show'
        # end
      end
    end

    describe 'Non-author user tries to update question' do
      before { login(user) }
      before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js }

      it "does not changes question attributes" do
        question.reload

        expect(question.body).to_not eq "New body"
      end

      it 're-render edit' do
        expect(response).to redirect_to answer.question
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: author) }

    describe 'author deletes answer' do
      before { login(author) }

      it "deletes an answer" do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      # it "re-renders question" do
      #   delete :destroy, params: { id: answer, question_id: question }, format: :js
      #   expect(response).to render_template 'questions/show'
      # end
    end

    describe 'non-author user tries to delete answer' do
      before { login(user) }

      it "doesnt deletes an answer" do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      # it "re-render question show" do
      #   delete :destroy, params: { id: answer, question_id: question }, format: :js
      #   expect(response).to render_template 'questions/show'
      # end
    end
  end

  describe 'PATCH #pick_best' do
    scenario 'non-Authenticated user tries to pick best answer' do
      patch :pick_best, params: { id: answer, answer: { best: true }, question_id: question }, format: :js
      answer.reload

      expect(answer.best).to_not eq true
    end

    scenario 'Authenticated non-author user tries to pick best answer' do
      sign_in(user)

      patch :pick_best, params: { id: answer, answer: { best: true }, question_id: question }, format: :js
      answer.reload

      expect(answer.best).to_not eq true
    end

    scenario 'Authenticated author user tries to pick best answer' do
      sign_in(author)

      patch :pick_best, params: { id: answer, answer: { best: true }, question_id: question }, format: :js
      answer.reload

      expect(answer.best).to eq true
    end
  end
end
