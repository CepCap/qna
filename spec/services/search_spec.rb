require 'rails_helper'

RSpec.describe Services::Search, type: :model do
  subject { Services::Search.new('query_string', 'Question') }

  describe '#call' do
    it 'should return search results' do
      allow(subject.type.constantize).to receive(:search).and_return('Search result')

      expect(subject.call).to eq 'Search result'
    end

    context 'with non-global type' do
      it 'should call search on individual classes' do
        Services::Search::TYPES.each do |type|
          next if %w[Global User].include?(type)

          object1 = create(type.downcase.to_sym, body: "#{type.downcase.to_sym} 1")
          object2 = create(type.downcase.to_sym, body: "#{type.downcase.to_sym} 2")
          service = Services::Search.new(type.downcase, type)

          expect(type.constantize).to receive(:search).with(service.query).and_return([object1, object2])
          service.call
        end
      end
    end

    context 'with global type' do
      it 'should make global search' do
        question = create(:question, title: 'shared question')
        answer = create(:answer, body: 'shared answer')
        comment = create(:comment, body: 'shared comment')
        user = create(:user, email: 'mail@shared.com')
        search_result = [question, answer, comment, user]
        service = Services::Search.new('shared', 'Global')

        expect(ThinkingSphinx).to receive(:search).with(service.query).and_return(search_result)
        service.call
      end
    end
  end

  describe '#check_errors' do
    context 'with invalid attributes' do
      it 'raises StandardError' do
        expect { Services::Search.new('', '').call }.to raise_error(StandardError)
      end
    end
  end
end
