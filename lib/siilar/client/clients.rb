module Siilar
  class Client

    def tracks
      @services[:tracks] ||= Client::TracksService.new(self)
    end

    class ClientService < ::Struct.new(:client)
    end

    require 'siilar/client/tracks'

    class TracksService < ClientService
      include Client::Tracks
    end
  end
end
