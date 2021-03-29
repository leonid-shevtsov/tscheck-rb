require 'spec_helper'

describe 'Demo' do
  describe 'Checking a response' do
    # In reality, this response might come from some API
    let(:response) {
      {
        items: [
          {
            name: 'Toaster',
            price: 100
          },
          {
            name: 'Blender',
            price: 150,
            discount: 20
          }
        ],
        total: 250
      }.to_json
    }

    it 'Returns a list of objects and a total' do
      expect(response).to match_ts_type('Cart', path: 'src/cart')
    end
  end

  describe 'Using a single file with all API types' do
    # the file is declared when setting up TSCheck in spec_helper

    describe 'Valid message' do
      subject { { message: 'It works!' } }
      it {  is_expected.to match_ts_type('MessageResponse') }
    end

    describe 'Something unexpected' do
      subject { { error: 'Uh oh' } }
      it { is_expected.to match_ts_type('MessageResponse') }
    end
  end
end
