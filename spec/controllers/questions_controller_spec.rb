require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to new question' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'doesnt saves a new question in DB' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders #new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    before { login(user) }

    context 'with valid attributes' do
      it "changes question attributes" do
        patch :update, params: { id: question, question: { title: "New title", body: "New body" } }
        question.reload

        expect(question.title).to eq "New title"
        expect(question.body).to eq "New body"
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: { title: "New title", body: "New body" } }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes'do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'doesnt changes question attributes' do
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    before { login(user) }

    it "deletes a question" do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it "redirects to #index" do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
