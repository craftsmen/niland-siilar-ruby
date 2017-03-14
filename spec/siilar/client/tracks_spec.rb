require 'spec_helper'

describe Siilar::Client, '.tracks' do
  subject { described_class.new(api_endpoint: 'http://api.niland', api_key: 'key').tracks }

  describe '#tracks' do
    before do
      stub_request(:get, %r[/2.0/tracks]).to_return(read_fixture('tags/list/success.http'))
    end

    it 'builds the correct request' do
      subject.tracks

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/tracks?key=key')
    end

    it 'returns the tracks' do
      result = subject.tracks

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#track' do
    before do
      stub_request(:get, %r[/2.0/tracks]).to_return(read_fixture('tracks/track/success.http'))
    end

    it 'builds the correct request' do
      track = 187069
      subject.track(track)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/tracks/187069?key=key')
    end

    it 'returns the track' do
      track = 187069
      result = subject.track(track)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#from_reference' do
    before do
      stub_request(:get, %r[/2.0/tracks/reference]).to_return(read_fixture('tracks/from_reference/success.http'))
    end

    it 'builds the correct request' do
      track = 88988
      subject.from_reference(track)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/tracks/reference/88988?key=key')
    end

    it 'returns the track' do
      track = 88988
      result = subject.from_reference(track)

      expect(result).to be_an(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#create' do
    before do
      stub_request(:post, %r[/2.0/tracks]).to_return(read_fixture('tracks/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { title: 'Nine Lives', reference: '1234' }
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/tracks?key=key')
                          .with(body: attributes)
    end

    it 'returns the track' do
      attributes = { title: 'Nine Lives', reference: '1234' }
      result = subject.create(attributes)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#update' do
    before do
      stub_request(:patch, %r[/2.0/tracks/.+]).to_return(read_fixture('tracks/update/success.http'))
    end

    it 'builds the correct request' do
      subject.update(1, { title: 'Updated' })

      expect(WebMock).to have_requested(:patch, 'http://api.niland/2.0/tracks/1?key=key')
                          .with(body: { title: 'Updated' })
    end

    it 'returns the track' do
      result = subject.update(1, {})

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/2.0]).to_return(read_fixture('tracks/notfound.http'))

        expect { subject.update(1, {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, %r[/2.0/tracks/1]).to_return(read_fixture("tracks/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, 'http://api.niland/2.0/tracks/1?key=key')
    end

    it 'returns nothing' do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/2.0/tracks/1]).to_return(read_fixture('tracks/delete/success-204.http'))

      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/2.0/tracks/1]).to_return(read_fixture('tracks/notfound.http'))

        expect { subject.delete(1) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#tags' do
    before do
      stub_request(:get, %r[/2.0/tracks/.+/tags]).to_return(read_fixture('tracks/track_tags/success.http'))
    end

    it 'builds the correct request' do
      subject.tags(187069)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/tracks/187069/tags?key=key')
    end

    it 'returns the tags' do
      result = subject.tags(187069)

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Tag)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#tags_from_reference' do
    before do
      stub_request(:get, %r[/2.0/tracks/reference/.+/tags]).to_return(read_fixture('tracks/track_tags/success.http'))
    end

    it 'builds the correct request' do
      subject.tags_from_reference(100001)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/tracks/reference/100001/tags?key=key')
    end

    it 'returns the tags' do
      result = subject.tags_from_reference(100001)

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Tag)
      expect(result.first.id).to be_a(Fixnum)
    end
  end
end
