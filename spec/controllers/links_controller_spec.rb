require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, author: author, links: [link]) }
  let!(:link) { create(:link) }

  describe 'DELETE #destroy' do
    scenario 'author deletes link' do
      sign_in(author)

      expect { delete :destroy, params: { id: link.id }, format: :js }.to change(Link, :count).by(-1)
    end

    scenario 'non-author user doesnt deletes link' do
      sign_in(user)

      expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
    end
  end
end
