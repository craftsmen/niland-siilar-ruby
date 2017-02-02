require 'spec_helper'

describe Siilar::Client, '.radios' do
  subject { described_class.new(api_endpoint: 'http://api.niland', api_key: 'key').radios }

  describe '#list' do
    before do
      stub_request(:get, %r[/2.0/radios]).to_return(read_fixture('radios/list/success.http'))
    end

    it 'builds the correct request' do
      subject.list

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/radios?key=key')
    end

    it 'returns the radio' do
      result = subject.list

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Radio)
      expect(result.first.id).to be_a(String)
    end
  end

  describe '#get' do
    before do
      stub_request(:get, %r[/2.0/radios/.+]).to_return(read_fixture('radios/get/success.http'))
    end

    it 'builds the correct request' do
      radio = "568bbb8be13aa0e8878b4567"
      subject.get(radio)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/radios/568bbb8be13aa0e8878b4567?key=key')
    end

    it 'returns the radio' do
      radio = 187069
      result = subject.get(radio)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#create' do
    before do
      stub_request(:post, %r[/2.0/radios]).to_return(read_fixture('radios/create/created.http'))
    end

    it 'builds the correct request' do
      attributes = { seeds: ["104428"], user: "14" }
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios?key=key')
                          .with(body: attributes)
    end

    it 'returns the radio' do
      attributes = { seeds: ["104428"], user: "14" }
      result = subject.create(attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#edit' do
    before do
      stub_request(:patch, %r[/2.0/radios/.+]).to_return(read_fixture('radios/edit/success.http'))
    end

    it 'builds the correct request' do
      attributes = { seeds: ["104428"], user: "14" }
      subject.edit("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:patch, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568?key=key')
                          .with(body: attributes)
    end

    it 'returns the radio' do
      attributes = { seeds: ["104428"], user: "14" }
      result = subject.edit("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end

    context 'when the request is not well formed' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/2.0]).to_return(read_fixture('radios/edit/badrequest.http'))

        expect { subject.edit("568bb450e13aa09d878b4568", {}) }.to raise_error(Siilar::RequestError)
      end
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:patch, %r[/2.0]).to_return(read_fixture('radios/notfound.http'))

        expect { subject.edit("568bb450e13aa09d878b4568", {}) }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, %r[/2.0/radios/.+]).to_return(read_fixture("radios/delete/success.http"))
    end

    it 'builds the correct request' do
      subject.delete("568bb450e13aa09d878b4568")

      expect(WebMock).to have_requested(:delete, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568?key=key')
    end

    it 'returns nothing' do
      result = subject.delete("568bb450e13aa09d878b4568")

      expect(result).to be_truthy
    end

    it 'supports HTTP 204' do
      stub_request(:delete, %r[/2.0/radios/.+]).to_return(read_fixture('radios/delete/success-204.http'))

      result = subject.delete("568bb450e13aa09d878b4568")

      expect(result).to be_truthy
    end

    context 'when something does not exist' do
      it 'raises NotFoundError' do
        stub_request(:delete, %r[/2.0/radios/.+]).to_return(read_fixture('radios/notfound.http'))

        expect { subject.delete("568bb450e13aa09d878b4568") }.to raise_error(Siilar::NotFoundError)
      end
    end
  end

  describe '#get_next' do
    before do
      stub_request(:get, %r[/2.0/radios/.+/next]).to_return(read_fixture('radios/get_next/success.http'))
    end

    it 'builds the correct request' do
      radio = "57ff39bfee47ed2a058b4568"
      subject.get_next(radio)

      expect(WebMock).to have_requested(:get, 'http://api.niland/2.0/radios/57ff39bfee47ed2a058b4568/next?key=key')
    end

    it 'returns the next radio tracks' do
      radio = "57ff39bfee47ed2a058b4568"
      result = subject.get_next(radio)

      expect(result).to be_an(Array)
      expect(result.first).to be_a(Siilar::Struct::Track)
      expect(result.first.id).to be_a(Integer)
    end
  end

  describe '#notify_skip' do
    before do
      stub_request(:post, %r[/2.0/radios/.+/skips]).to_return(read_fixture('radios/notify_skip/created.http'))
    end

    it 'builds the correct request with track' do
      attributes = { track: 125052 }
      subject.notify_skip("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/skips?key=key')
                          .with(body: attributes)
    end

    it 'builds the correct request with reference' do
      attributes = { reference: 10266 }
      subject.notify_skip("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/skips?key=key')
                          .with(body: attributes)
    end

    it 'does not accept track and reference at the same time' do
      attributes = { track: 125052, reference: 10266 }
      expect { subject.notify_skip("568bb450e13aa09d878b4568", attributes) }.to raise_error(ArgumentError)
    end

    it 'returns the radio' do
      attributes = { track: 125052 }
      result = subject.notify_skip("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#notify_like' do
    before do
      stub_request(:post, %r[/2.0/radios/.+/likes]).to_return(read_fixture('radios/notify_like/created.http'))
    end

    it 'builds the correct request with track' do
      attributes = { track: 125052 }
      subject.notify_like("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/likes?key=key')
                          .with(body: attributes)
    end

    it 'builds the correct request with reference' do
      attributes = { reference: 10266 }
      subject.notify_like("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/likes?key=key')
                          .with(body: attributes)
    end

    it 'does not accept track and reference at the same time' do
      attributes = { track: 125052, reference: 10266 }
      expect { subject.notify_skip("568bb450e13aa09d878b4568", attributes) }.to raise_error(ArgumentError)
    end

    it 'returns the radio' do
      attributes = { track: 125052 }
      result = subject.notify_like("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#notify_dislike' do
    before do
      stub_request(:post, %r[/2.0/radios/.+/dislikes]).to_return(read_fixture('radios/notify_dislike/created.http'))
    end

    it 'builds the correct request with track' do
      attributes = { track: 125052 }
      subject.notify_dislike("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/dislikes?key=key')
                          .with(body: attributes)
    end

    it 'builds the correct request with reference' do
      attributes = { reference: 10266 }
      subject.notify_dislike("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/dislikes?key=key')
                          .with(body: attributes)
    end

    it 'does not accept track and reference at the same time' do
      attributes = { track: 125052, reference: 10266 }
      expect { subject.notify_skip("568bb450e13aa09d878b4568", attributes) }.to raise_error(ArgumentError)
    end

    it 'returns the radio' do
      attributes = { track: 125052 }
      result = subject.notify_dislike("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#notify_ban' do
    before do
      stub_request(:post, %r[/2.0/radios/.+/bans]).to_return(read_fixture('radios/notify_ban/created.http'))
    end

    it 'builds the correct request with track' do
      attributes = { track: 125052 }
      subject.notify_ban("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/bans?key=key')
                          .with(body: attributes)
    end

    it 'builds the correct request with reference' do
      attributes = { reference: 10266 }
      subject.notify_ban("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/bans?key=key')
                          .with(body: attributes)
    end

    it 'does not accept track and reference at the same time' do
      attributes = { track: 125052, reference: 10266 }
      expect { subject.notify_skip("568bb450e13aa09d878b4568", attributes) }.to raise_error(ArgumentError)
    end

    it 'returns the radio' do
      attributes = { track: 125052 }
      result = subject.notify_ban("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#notify_favorite' do
    before do
      stub_request(:post, %r[/2.0/radios/.+/favorites]).to_return(read_fixture('radios/notify_favorite/created.http'))
    end

    it 'builds the correct request with track' do
      attributes = { track: 125052 }
      subject.notify_favorite("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/favorites?key=key')
                          .with(body: attributes)
    end

    it 'builds the correct request with reference' do
      attributes = { reference: 10266 }
      subject.notify_favorite("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/favorites?key=key')
                          .with(body: attributes)
    end

    it 'does not accept track and reference at the same time' do
      attributes = { track: 125052, reference: 10266 }
      expect { subject.notify_skip("568bb450e13aa09d878b4568", attributes) }.to raise_error(ArgumentError)
    end

    it 'returns the radio' do
      attributes = { track: 125052 }
      result = subject.notify_favorite("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

  describe '#notify_not_played' do
    before do
      stub_request(:post, %r[/2.0/radios/.+/notplayed]).to_return(read_fixture('radios/notify_not_played/created.http'))
    end

    it 'builds the correct request with track' do
      attributes = { track: 125052 }
      subject.notify_not_played("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/notplayed?key=key')
                          .with(body: attributes)
    end

    it 'builds the correct request with reference' do
      attributes = { reference: 10266 }
      subject.notify_not_played("568bb450e13aa09d878b4568", attributes)

      expect(WebMock).to have_requested(:post, 'http://api.niland/2.0/radios/568bb450e13aa09d878b4568/notplayed?key=key')
                          .with(body: attributes)
    end

    it 'does not accept track and reference at the same time' do
      attributes = { track: 125052, reference: 10266 }
      expect { subject.notify_skip("568bb450e13aa09d878b4568", attributes) }.to raise_error(ArgumentError)
    end

    it 'returns the radio' do
      attributes = { track: 125052 }
      result = subject.notify_not_played("568bb450e13aa09d878b4568", attributes)

      expect(result).to be_a(Siilar::Struct::Radio)
      expect(result.id).to be_a(String)
    end
  end

end
