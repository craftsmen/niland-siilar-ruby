require 'spec_helper'

describe Siilar::Client, '.search' do
  subject { described_class.new(api_endpoint: 'http://api.niland', api_key: 'key').search }

  describe '#tracks' do
    before do
      stub_request(:get, %r[/2.0/tracks/search]).to_return(read_fixture('search/tracks/success.http'))
    end

    it 'builds the correct request' do
      attributes = { similar_tracks: '1234' }
      subject.tracks(attributes)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/tracks/search?similar_tracks=1234&key=key')
                          .with(query: attributes)
    end

    it 'returns the search results' do
      attributes = { similar_tracks: '1234' }
      result = subject.tracks(attributes)

      expect(result).to be_a(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.album).to be_a(Siilar::Struct::Album)
      expect(result.first.artist).to be_a(Siilar::Struct::Artist)
    end
  end

  describe '#suggestions' do
    before do
      stub_request(:get, %r[/2.0/suggestions]).to_return(read_fixture('search/suggestions/success.http'))
    end

    it 'builds the correct request' do
      attributes = { query: 'radioh' }
      subject.suggestions(attributes)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/suggestions?key=key')
                          .with(query: attributes)
    end

    it 'returns the search results' do
      attributes = { query: 'radioh' }
      result = subject.suggestions(attributes)

      expect(result).to be_a(Siilar::Struct::Suggestion)
      expect(result.tracks.first).to be_a(Siilar::Struct::Track)
      expect(result.tags.first).to be_a(Siilar::Struct::Tag)
    end
  end
end
