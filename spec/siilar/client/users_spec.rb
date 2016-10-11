require 'spec_helper'

describe Siilar::Client, '.users' do
  subject { described_class.new(api_endpoint: 'http://api.niland', api_key: 'key').users }

  describe '#list' do
    before do
      stub_request(:get, %r[/2.0/users]).to_return(read_fixture('users/list/success.http'))
    end

    it 'builds the correct request' do
      subject.list

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/users?key=key')
    end

    it 'returns the user' do
      result = subject.list

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::User)
      expect(result.first.reference).to be_a(String)
    end
  end

  describe '#get' do
    before do
      stub_request(:get, %r[/2.0/users/.+]).to_return(read_fixture('users/get/success.http'))
    end

    it 'builds the correct request' do
      user = "14"
      subject.get(user)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/users/14?key=key')
    end

    it 'returns the user' do
      user = "14"
      result = subject.get(user)

      expect(result).to be_a(Siilar::Struct::User)
      expect(result.reference).to be_a(String)
    end
  end

  describe '#create' do
    before do
      stub_request(:post, %r[/2.0/users]).to_return(read_fixture('users/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { reference: "21", gender: "F", birth_date: "1992-03-21" }
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/users?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { reference: "21", gender: "F", birth_date: "1992-03-21" }
      result = subject.create(attributes)

      expect(result).to be_a(Siilar::Struct::User)
      expect(result.reference).to be_a(String)
    end
  end

  describe '#update' do
    before do
      stub_request(:patch, %r[/2.0/users/.+]).to_return(read_fixture('users/update/success.http'))
    end

    it 'builds the correct request' do
      attributes = { country: "France" }
      subject.update("14", attributes)

      expect(WebMock).to have_requested(:patch, 'http://api.niland/2.0/users/14?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { country: "France" }
      result = subject.update("14", attributes)

      expect(result).to be_a(Siilar::Struct::User)
      expect(result.reference).to be_a(String)
    end

    context 'when the request is not well formed' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/2.0]).to_return(read_fixture('users/update/badrequest.http'))

        expect { subject.update("14", {}) }.to raise_error(Siilar::RequestError)
      end
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/2.0]).to_return(read_fixture('users/notfound.http'))

        expect { subject.update("14", {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end


  describe '#delete' do
    before do
      stub_request(:delete, %r[/2.0/users/1]).to_return(read_fixture('users/delete/success-204.http'))
    end

    it 'builds the correct request' do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, 'http://api.niland/2.0/users/1?key=key')
    end

    it 'returns nothing' do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/2.0/users/1]).to_return(read_fixture('users/notfound.http'))

        expect { subject.delete(1) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#get_likes' do
    before do
      stub_request(:get, %r[/2.0/users/.+/likes]).to_return(read_fixture('users/get_likes/success.http'))
    end

    it 'builds the correct request' do
      subject.get_likes("14")

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/users/14/likes?key=key')
    end

    it 'returns the user' do
      result = subject.get_likes("14")

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#add_like' do
    before do
      stub_request(:post, %r[/2.0/users/.+/likes]).to_return(read_fixture('users/add_like/success.http'))
    end

    it 'builds the correct request' do
      attributes = { track: 104428 }
      subject.add_like("14", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/users/14/likes?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { track: 104428 }
      result = subject.add_like("14", attributes)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#get_dislikes' do
    before do
      stub_request(:get, %r[/2.0/users/.+/dislikes]).to_return(read_fixture('users/get_dislikes/success.http'))
    end

    it 'builds the correct request' do
      subject.get_dislikes("14")

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/users/14/dislikes?key=key')
    end

    it 'returns the user' do
      result = subject.get_dislikes("14")

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#add_dislike' do
    before do
      stub_request(:post, %r[/2.0/users/.+/dislikes]).to_return(read_fixture('users/add_dislike/success.http'))
    end

    it 'builds the correct request' do
      attributes = { track: 104428 }
      subject.add_dislike("14", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/users/14/dislikes?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { track: 104428 }
      result = subject.add_dislike("14", attributes)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end
end
