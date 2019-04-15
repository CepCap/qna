require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#validate_link_url' do
    let(:valid_link) { create(:link) }
    let(:invalid_link) { create(:link, url: 'Not a link') }

    it 'raises an error if link url is invalid' do
      invalid_link.valid?
      expect(invalid_link.errors.full_messages).to include("Url Invalid url format")
    end
  end
end
