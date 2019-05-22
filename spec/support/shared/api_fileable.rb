shared_examples_for 'API fileable' do
  include Rails.application.routes.url_helpers

  context 'file links' do
    let(:headers) { nil }

    before do
      resource.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    it 'contains link for files' do
      %w[url].each do |attr|
        expect(file_response.first[attr]).to eq rails_blob_path(resource.files.first, only_path: true)
      end
    end

    it 'contains only allowed data' do
      expect(file_response.first.size).to eq 1
    end
  end
end
