require 'spec_helper'

describe Siilar::Client, '.tags' do
  subject { described_class.new(api_endpoint: 'http://api.siilar', api_key: 'key').tags }

  describe '#create_tag_collection' do
    before do
      stub_request(:post, %r[/1.0/tag-collections]).to_return(read_fixture('tags/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { name: 'Niland Moods', description: 'Niland Moods' }
      subject.create_tag_collection(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.siilar/1.0/tag-collections?key=key')
                          .with(body: attributes)
    end

    it 'returns the tag collection' do
      attributes = { name: 'Niland Moods', description: 'Niland Moods' }
      result = subject.create_tag_collection(attributes)

      expect(result).to be_a(Siilar::Struct::TagCollection)
      expect(result.id).to be_a(String)
      expect(result.tags.first.id).to be_a(Fixnum)
    end
  end

  describe '#edit_tag_collection' do
    before do
      stub_request(:patch, %r[/1.0/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture('tags/update/success.http'))
    end

    it 'builds the correct request' do
      subject.edit_tag_collection("54d823e858172f11df4919d8", { name: 'Updated' })

      expect(WebMock).to have_requested(:patch, 'http://api.siilar/1.0/tag-collections/54d823e858172f11df4919d8?key=key')
                          .with(body: { name: 'Updated' })
    end

    it 'returns the tag collection' do
      result = subject.edit_tag_collection("54d823e858172f11df4919d8", {})

      expect(result).to be_a(Siilar::Struct::TagCollection)
      expect(result.id).to be_a(String)
      expect(result.tags.first.id).to be_a(Fixnum)
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/1.0]).to_return(read_fixture('tags/notfound.http'))

        expect { subject.edit_tag_collection("54d823e858172f11df4919d8", {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete_tag_collection' do
    before do
      stub_request(:delete, %r[/1.0/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture("tags/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete_tag_collection("54d823e858172f11df4919d8")

      expect(WebMock).to have_requested(:delete, 'http://api.siilar/1.0/tag-collections/54d823e858172f11df4919d8?key=key')
    end

    it 'returns nothing' do
      result = subject.delete_tag_collection("54d823e858172f11df4919d8")

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/1.0/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture('tags/delete/success-204.http'))

      result = subject.delete_tag_collection("54d823e858172f11df4919d8")

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/1.0/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture('tags/notfound.http'))

        expect { subject.delete_tag_collection("54d823e858172f11df4919d8") }.to raise_error(Siilar::NotFoundError)
      end
    end
  end
end
