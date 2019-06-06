class SearchesController < ApplicationController
  skip_authorization_check

  def index
  end

  def create
    redirect_to action: 'result', type: params['type'], query: params['query']
  end

  def result
    @results = search_service.call
  end

  private

  def search_service
    Services::Search.new(params['query'], params['type'])
  end
end
