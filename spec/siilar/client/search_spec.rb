require 'spec_helper'

describe Siilar::Client, '.search' do
  subject { described_class.new(api_endpoint: 'http://api.siilar', api_key: 'key').search }

  describe '#search' do
    before do
      stub_request(:get, %r[/1.0/search]).to_return(read_fixture('search/list/success.http'))
    end

    it 'builds the correct request' do
      attributes = { similar_tracks: '1234' }
      subject.search(attributes)

      expect(WebMock).to have_requested(:get, 'http://api.siilar/1.0/search?similar_tracks=1234&key=key')
                          .with(query: attributes)
    end

    it 'returns the search results' do
      attributes = { similar_tracks: '1234' }
      result = subject.search(attributes)

      expect(result).to be_a(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.album).to be_a(Siilar::Struct::Album)
      expect(result.first.artist).to be_a(Siilar::Struct::Artist)
    end
  end
end
