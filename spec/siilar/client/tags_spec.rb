require 'spec_helper'

describe Siilar::Client, '.tags' do
  subject { described_class.new(api_endpoint: 'http://api.niland.io/2.0', api_key: 'key').tags }

  describe '#tag_collections' do
    before do
      stub_request(:get, %r[/tag-collections]).to_return(read_fixture('tags/list_collections/success.http'))
    end

    it 'builds the correct request' do
      subject.tag_collections

      expect(WebMock).to have_requested(:get, 'http://api.niland.io/2.0/tag-collections?key=key')
    end

    it 'returns the tag-collection' do
      result = subject.tag_collections

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::TagCollection)
      expect(result.first.id).to be_a(String)
    end
  end

  describe '#tag_collection' do
    before do
      stub_request(:get, %r[/tag-collections/.+]).to_return(read_fixture('tags/get_collection/success.http'))
    end

    it 'builds the correct request' do
      tag_collection = "54d823e858172f11df4919d3"
      subject.tag_collection(tag_collection)

      expect(WebMock).to have_requested(:get, 'http://api.niland.io/2.0/tag-collections/54d823e858172f11df4919d3?key=key')
    end

    it 'returns the tag-collection' do
      tag_collection = "54d823e858172f11df4919d3"
      result = subject.tag_collection(tag_collection)


      expect(result).to be_a(Siilar::Struct::TagCollection)
      expect(result.id).to be_a(String)
      expect(result.tags.first).to be_a(Siilar::Struct::Tag)
      expect(result.tags.first.id).to be_a(Fixnum)
    end
  end

  describe '#create_tag_collection' do
    before do
      stub_request(:post, %r[/tag-collections]).to_return(read_fixture('tags/create_collection/created.http'))
    end

    it 'builds the correct request' do
      attributes = { name: 'Niland Moods', description: 'Niland Moods' }
      subject.create_tag_collection(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland.io/2.0/tag-collections?key=key')
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
      stub_request(:patch, %r[/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture('tags/update_collection/success.http'))
    end

    it 'builds the correct request' do
      subject.edit_tag_collection("54d823e858172f11df4919d8", { name: 'Updated' })

      expect(WebMock).to have_requested(:patch, 'http://api.niland.io/2.0/tag-collections/54d823e858172f11df4919d8?key=key')
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
        stub_request(:patch, %r[]).to_return(read_fixture('tags/notfound.http'))

        expect { subject.edit_tag_collection("54d823e858172f11df4919d8", {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete_tag_collection' do
    before do
      stub_request(:delete, %r[/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture("tags/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete_tag_collection("54d823e858172f11df4919d8")

      expect(WebMock).to have_requested(:delete, 'http://api.niland.io/2.0/tag-collections/54d823e858172f11df4919d8?key=key')
    end

    it 'returns nothing' do
      result = subject.delete_tag_collection("54d823e858172f11df4919d8")

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture('tags/delete/success-204.http'))

      result = subject.delete_tag_collection("54d823e858172f11df4919d8")

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/tag-collections/54d823e858172f11df4919d8]).to_return(read_fixture('tags/notfound.http'))

        expect { subject.delete_tag_collection("54d823e858172f11df4919d8") }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#find_tags' do
    before do
      stub_request(:get, %r[/tags]).to_return(read_fixture('tags/list/success.http'))
    end

    it 'builds the correct request' do
      attributes = { query: 'pia' }
      subject.find_tags(attributes)

      expect(WebMock).to have_requested(:get, 'http://api.niland.io/2.0/tags?key=key&query=pia')
    end

    it 'returns the tags' do
      result = subject.find_tags

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Tag)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#tag' do
    before do
      stub_request(:get, %r[/tags/.+]).to_return(read_fixture('tags/get/success.http'))
    end

    it 'builds the correct request' do
      tag = 5000
      subject.tag(tag)

      expect(WebMock).to have_requested(:get, 'http://api.niland.io/2.0/tags/5000?key=key')
    end

    it 'returns the tag' do
      tag = 5000
      result = subject.tag(tag)


      expect(result).to be_a(Siilar::Struct::Tag)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#create_tag' do
    before do
      stub_request(:post, %r[/tags]).to_return(read_fixture('tags/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { title: 'Agressive_Intense', tag_collection: 'Niland Moods' }
      subject.create_tag(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland.io/2.0/tags?key=key')
                          .with(body: attributes)
    end

    it 'returns the tag' do
      attributes = { title: 'Agressive_Intense', tag_collection: 'Niland Moods' }
      result = subject.create_tag(attributes)

      expect(result).to be_a(Siilar::Struct::Tag)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#edit_tag' do
    before do
      stub_request(:patch, %r[/tags/5000]).to_return(read_fixture('tags/update/success.http'))
    end

    it 'builds the correct request' do
      subject.edit_tag(5000, { title: 'Updated' })

      expect(WebMock).to have_requested(:patch, 'http://api.niland.io/2.0/tags/5000?key=key')
                          .with(body: { title: 'Updated' })
    end

    it 'returns the tag' do
      result = subject.edit_tag(5000, {})

      expect(result).to be_a(Siilar::Struct::Tag)
      expect(result.id).to be_a(Fixnum)
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/]).to_return(read_fixture('tags/notfound.http'))

        expect { subject.edit_tag(5000, {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete_tag' do
    before do
      stub_request(:delete, %r[/tags/5000]).to_return(read_fixture("tags/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete_tag(5000)

      expect(WebMock).to have_requested(:delete, 'http://api.niland.io/2.0/tags/5000?key=key')
    end

    it 'returns nothing' do
      result = subject.delete_tag(5000)

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/tags/5000]).to_return(read_fixture('tags/delete/success-204.http'))

      result = subject.delete_tag(5000)

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/tags/5000]).to_return(read_fixture('tags/notfound.http'))

        expect { subject.delete_tag(5000) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end
end
