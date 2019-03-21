require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, author: author, question: question) }


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in DB' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'saves user as an author' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(user.answers, :count).by(1)
      end

      it 'saves the association to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save a new answer in DB' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders question' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do

    describe 'author updates answer' do
      before { login(author) }

      context 'with valid attributes' do
        it "changes answer attributes" do
          patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }
          answer.reload

          expect(answer.body).to eq "New body"
        end

        it 'redirects back to question' do
          patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }
          expect(response).to redirect_to answer.question
        end
      end

      context 'with invalid attributes'do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question } }

        it 'doesnt changes answer attributes' do
          answer.reload

          expect(answer.body).to eq "MyText"
        end

        it 're-renders edit' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Non-author user tries to update question' do
      before { login(user) }
      before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question } }

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
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it "re-renders question" do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end

    describe 'non-author user tries to delete answer' do
      before { login(user) }

      it "doesnt delete an answer" do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
      end

      it "re-render question show" do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
