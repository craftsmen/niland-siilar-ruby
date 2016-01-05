require 'spec_helper'

describe Siilar::Client, '.users' do
  subject { described_class.new(api_endpoint: 'http://api.niland', api_key: 'key').users }

  describe '#list' do
    before do
      stub_request(:get, %r[/1.0/users]).to_return(read_fixture('users/list/success.http'))
    end

    it 'builds the correct request' do
      subject.list

      expect(WebMock).to have_requested(:get, 'http://api.niland/1.0/users?key=key')
    end

    it 'returns the user' do
      result = subject.list

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::User)
      expect(result.first.external_id).to be_a(String)
    end
  end

  describe '#get' do
    before do
      stub_request(:get, %r[/1.0/users/.+]).to_return(read_fixture('users/get/success.http'))
    end

    it 'builds the correct request' do
      user = "14"
      subject.get(user)

      expect(WebMock).to have_requested(:get, 'http://api.niland/1.0/users/14?key=key')
    end

    it 'returns the user' do
      user = "14"
      result = subject.get(user)

      expect(result).to be_a(Siilar::Struct::User)
      expect(result.external_id).to be_a(String)
    end
  end

  describe '#create' do
    before do
      stub_request(:post, %r[/1.0/users]).to_return(read_fixture('users/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { external_id: "21", gender: "F", birth_date: "1992-03-21" }
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/1.0/users?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { external_id: "21", gender: "F", birth_date: "1992-03-21" }
      result = subject.create(attributes)

      expect(result).to be_a(Siilar::Struct::User)
      expect(result.external_id).to be_a(String)
    end
  end

  describe '#update' do
    before do
      stub_request(:patch, %r[/1.0/users/.+]).to_return(read_fixture('users/update/success.http'))
    end

    it 'builds the correct request' do
      attributes = { country: "France" }
      subject.update("14", attributes)

      expect(WebMock).to have_requested(:patch, 'http://api.niland/1.0/users/14?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { country: "France" }
      result = subject.update("14", attributes)

      expect(result).to be_a(Siilar::Struct::User)
      expect(result.external_id).to be_a(String)
    end

    context 'when the request is not well formed' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/1.0]).to_return(read_fixture('users/update/badrequest.http'))

        expect { subject.update("14", {}) }.to raise_error(Siilar::RequestError)
      end
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/1.0]).to_return(read_fixture('users/notfound.http'))

        expect { subject.update("14", {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end


  describe '#delete' do
    before do
      stub_request(:delete, %r[/1.0/users/1]).to_return(read_fixture('users/delete/success-204.http'))
    end

    it 'builds the correct request' do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, 'http://api.niland/1.0/users/1?key=key')
    end

    it 'returns nothing' do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/1.0/users/1]).to_return(read_fixture('users/notfound.http'))

        expect { subject.delete(1) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#get_liked_tracks' do
    before do
      stub_request(:get, %r[/1.0/users/.+/likes]).to_return(read_fixture('users/get_liked_tracks/success.http'))
    end

    it 'builds the correct request' do
      subject.get_liked_tracks("14")

      expect(WebMock).to have_requested(:get, 'http://api.niland/1.0/users/14/likes?key=key')
    end

    it 'returns the user' do
      result = subject.get_liked_tracks("14")

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#add_liked_track' do
    before do
      stub_request(:post, %r[/1.0/users/.+/likes]).to_return(read_fixture('users/add_liked_track/success.http'))
    end

    it 'builds the correct request' do
      attributes = { track: 104428 }
      subject.add_liked_track("14", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/1.0/users/14/likes?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { track: 104428 }
      result = subject.add_liked_track("14", attributes)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe '#get_disliked_tracks' do
    before do
      stub_request(:get, %r[/1.0/users/.+/dislikes]).to_return(read_fixture('users/get_disliked_tracks/success.http'))
    end

    it 'builds the correct request' do
      subject.get_disliked_tracks("14")

      expect(WebMock).to have_requested(:get, 'http://api.niland/1.0/users/14/dislikes?key=key')
    end

    it 'returns the user' do
      result = subject.get_disliked_tracks("14")

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.id).to be_a(Fixnum)
    end
  end

  describe '#add_disliked_track' do
    before do
      stub_request(:post, %r[/1.0/users/.+/dislikes]).to_return(read_fixture('users/add_disliked_track/success.http'))
    end

    it 'builds the correct request' do
      attributes = { track: 104428 }
      subject.add_disliked_track("14", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/1.0/users/14/dislikes?key=key')
                          .with(body: attributes)
    end

    it 'returns the user' do
      attributes = { track: 104428 }
      result = subject.add_disliked_track("14", attributes)

      expect(result).to be_a(Siilar::Struct::Track)
      expect(result.id).to be_a(Fixnum)
    end
  end
end
