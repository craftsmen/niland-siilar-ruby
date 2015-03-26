require 'spec_helper'

describe Siilar::Client, '.tracks' do
  subject { described_class.new(api_endpoint: 'http://api.siilar', api_key: 'key').tracks }

  describe '#create' do
    before do
      stub_request(:post, %r[/v1/tracks]).to_return(read_fixture('tracks/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { title: 'Nine Lives', external_id: '1234' }
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.siilar/v1/tracks?key=key')
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
      stub_request(:patch, %r[/v1/tracks/.+]).to_return(read_fixture('tracks/update/success.http'))
    end

    it 'builds the correct request' do
      subject.update(1, { title: 'Updated' })

      expect(WebMock).to have_requested(:patch, 'http://api.siilar/v1/tracks/1?key=key')
                          .with(body: { title: 'Updated' })
    end

    it 'returns the track' do
      result = subject.update(1, {})

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/v1]).to_return(read_fixture('tracks/notfound.http'))

        expect { subject.update(1, {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, %r[/v1/tracks/1]).to_return(read_fixture("tracks/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, 'http://api.siilar/v1/tracks/1?key=key')
    end

    it 'returns nothing' do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/v1/tracks/1]).to_return(read_fixture('tracks/delete/success-204.http'))

      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/v1/tracks/1]).to_return(read_fixture('tracks/notfound.http'))

        expect { subject.delete(1) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end
end
