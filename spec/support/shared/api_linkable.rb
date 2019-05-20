shared_examples_for 'API linkable' do
  context 'links' do
    it 'contains links' do
      expect(link_response.first['id']).to eq link.id
    end

    it 'contain all related to resource links' do
      expect(link_response.size).to eq 2
    end

    it 'contains url for links' do
      %w[id url].each do |attr|
        expect(link_response.first[attr]).to eq link.send(attr).as_json
      end
    end

    it 'contains only allowed data' do
      expect(link_response.first.size).to eq 3
    end
  end
end
