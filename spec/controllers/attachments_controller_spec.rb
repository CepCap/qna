require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:author) { create(:user) }
    let!(:question) {create(:question, author: author)}
    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
    end

    describe 'Unauthorized user' do
      it 'tries to delete an attachment' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to_not change(question.files, :count).by(-1)
      end
    end

    describe 'Authorized, non-author user' do
      before do
        login(user)
      end

      it 'tries to delete an attachment' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to_not change(question.files, :count).by(-1)
      end
    end

    describe 'Author user' do
      before do
        login(author)
      end

      it 'deletes an attachment' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to change(question.files, :count).by(-1)
      end
    end
  end
end
