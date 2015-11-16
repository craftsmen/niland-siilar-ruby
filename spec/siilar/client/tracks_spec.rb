require 'spec_helper'

describe Siilar::Client, '.tracks' do
  subject { described_class.new(api_endpoint: 'http://api.siilar', api_key: 'key').tracks }

  describe '#track' do
    before do
      stub_request(:get, %r[/1.0/tracks]).to_return(read_fixture('tracks/track/success.http'))
    end

    it 'builds the correct request' do
      track = 187069
      subject.track(track)

      expect(WebMock).to have_requested(:get, 'http://api.siilar/1.0/tracks/187069?key=key')
    end

    it 'returns the track' do
      track = 187069
      result = subject.track(track)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#external_track' do
    before do
      stub_request(:get, %r[/1.0/external-tracks]).to_return(read_fixture('tracks/external_track/success.http'))
    end

    it 'builds the correct request' do
      track = 1151525
      subject.external_track(track)

      expect(WebMock).to have_requested(:get, 'http://api.siilar/1.0/external-tracks/1151525?key=key')
    end

    it 'returns the track' do
      track = 1151525
      result = subject.external_track(track)

      expect(result).to be_a(Siilar::Struct::ExternalTrack)
      expect(result.external_id).to be_a(Fixnum)
    end
  end

  describe '#create' do
    before do
      stub_request(:post, %r[/1.0/tracks]).to_return(read_fixture('tracks/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { title: 'Nine Lives', external_id: '1234' }
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.siilar/1.0/tracks?key=key')
                          .with(body: attributes)
    end

    it 'returns the track' do
      attributes = { title: 'Nine Lives', external_id: '1234' }
      result = subject.create(attributes)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#update' do
    before do
      stub_request(:patch, %r[/1.0/tracks/.+]).to_return(read_fixture('tracks/update/success.http'))
    end

    it 'builds the correct request' do
      subject.update(1, { title: 'Updated' })

      expect(WebMock).to have_requested(:patch, 'http://api.siilar/1.0/tracks/1?key=key')
                          .with(body: { title: 'Updated' })
    end

    it 'returns the track' do
      result = subject.update(1, {})

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/1.0]).to_return(read_fixture('tracks/notfound.http'))

        expect { subject.update(1, {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, %r[/1.0/tracks/1]).to_return(read_fixture("tracks/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, 'http://api.siilar/1.0/tracks/1?key=key')
    end

    it 'returns nothing' do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/1.0/tracks/1]).to_return(read_fixture('tracks/delete/success-204.http'))

      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/1.0/tracks/1]).to_return(read_fixture('tracks/notfound.http'))

        expect { subject.delete(1) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end
end
