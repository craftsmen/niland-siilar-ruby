require 'spec_helper'

describe Siilar::Client do

  describe 'initialization' do
    it 'accepts :api_endpoint option' do
      subject = described_class.new(api_endpoint: 'https://api.example.com/')

      expect(subject.api_endpoint).to eq('https://api.example.com/')
    end

    it 'normalizes :api_endpoint trailing slash' do
      subject = described_class.new(api_endpoint: 'https://api.example.com/missing/slash')

      expect(subject.api_endpoint).to eq('https://api.example.com/missing/slash/')
    end

    it 'defaults :api_endpoint to production API' do
      subject = described_class.new

      expect(subject.api_endpoint).to eq('https://api.niland.io/')
    end
  end

  describe 'authentication' do
    it 'raises an error if there is no api key provided' do
      subject = described_class.new

      expect {
        subject.execute(:get, 'test', {})
      }.to raise_error(Siilar::Error, 'An API key is required for all API requests.')
    end
  end

  describe '#get' do
    it 'delegates to #request' do
      expect(subject).to receive(:execute).with(:get, "path", { foo: 'bar' }).and_return(:returned)
      expect(subject.get('path', foo: 'bar')).to eq(:returned)
    end
  end

  describe '#post' do
    it 'delegates to #request' do
      expect(subject).to receive(:execute).with(:post, "path", { foo: 'bar' }).and_return(:returned)
      expect(subject.post('path', foo: 'bar')).to eq(:returned)
    end
  end

  describe '#patch' do
    it 'delegates to #request' do
      expect(subject).to receive(:execute).with(:patch, 'path', { foo: 'bar' }).and_return(:returned)
      expect(subject.patch('path', foo: 'bar')).to eq(:returned)
    end
  end

  describe '#delete' do
    it 'delegates to #request' do
      expect(subject).to receive(:execute).with(:delete, 'path', { foo: 'bar' }).and_return(:returned)
      expect(subject.delete('path', foo: 'bar')).to eq(:returned)
    end
  end

  describe '#execute' do
    subject { described_class.new(api_key: 'key') }

    it 'raises RequestError in case of error' do
      stub_request(:get, %r[/foo]).
          to_return(status: [500, 'Internal Server Error'])

      expect {
        subject.execute(:get, 'foo', {})
      }.to raise_error(Siilar::RequestError, '500')
    end
  end

  describe '#request' do
    subject { described_class.new(api_key: 'key') }

    it 'performs a request' do
      stub_request(:get, %r[/foo])

      subject.request(:get, 'foo', {})

      expect(WebMock)
        .to have_requested(:get, 'https://api.niland.io/foo?key=key')
        .with(
          headers: {
            'Accept' => 'application/json',
            'User-Agent' => "niland-siilar-ruby/#{Siilar::VERSION}"
          },
          query: { key: 'key' }
        )
    end

    it 'delegates to HTTParty' do
      stub_request(:get, %r[/foo])

      expect(HTTParty)
        .to receive(:get)
        .with("#{subject.api_endpoint}foo",
          format: :json,
          headers: {
            'Accept' => 'application/json',
            'Content-type' => 'application/json',
            'User-Agent' => "niland-siilar-ruby/#{Siilar::VERSION}"
          },
          timeout: 10,
          query: { key: 'key' }
        ).and_return(double('response', code: 200))

      subject.request(:get, 'foo', {})
    end

    it 'properly extracts options from data' do
      expect(HTTParty)
        .to receive(:patch)
        .with("#{subject.api_endpoint}foo",
          format: :json,
          headers: {
            'Accept' => 'application/json',
            'Content-type' => 'application/json',
            'User-Agent' => "niland-siilar-ruby/#{Siilar::VERSION}",
            'Custom' => 'Header'
          },
          timeout: 10,
          query: { key: 'key', foo: 'bar' },
          body: { something: 'else' }.to_json
        )
        .and_return(double('response', code: 200))

      subject.request(
        :patch,
        'foo',
        { something: 'else', query: { foo: 'bar' }, headers: { 'Custom' => 'Header' } }
      )
    end
  end
end
