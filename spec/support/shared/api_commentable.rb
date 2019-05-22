shared_examples_for 'API commentable' do
  context 'comments' do
    it 'contains all comments' do
      expect(comment_response.size).to eq 3
    end

    it 'returns all public fields of comments' do
      %w[id body created_at updated_at].each do |attr|
        expect(comment_response.last[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
