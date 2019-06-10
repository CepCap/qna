require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    it 'renders index' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    it 'redirects to search_result' do
      post :create, params: { query: 'example_query', type: 'Question' }

      expect(response).to redirect_to action: :result, query: 'example_query', type: 'Question'
    end
  end

  describe 'GET #result' do
    let(:service) { double('Services::Search') }

    before { allow(Services::Search).to receive(:new).and_return(service) }

    it 'calls search service' do
      expect(service).to receive(:call)
      get :result, params: { query: 'some_query', type: 'correct_type' }
    end

    it 'renders result template' do
      allow(service).to receive(:call)
      get :result, params: { query: 'some_query', type: 'correct_type' }
      expect(response).to render_template :result
    end
  end
end
