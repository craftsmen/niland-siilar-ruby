module Siilar
  class Client

    def tracks
      @services[:tracks] ||= Client::TracksService.new(self)
    end

    def search
      @services[:search] ||= Client::SearchService.new(self)
    end

    def tags
      @services[:tags] ||= Client::TagsService.new(self)
    end

    class ClientService < ::Struct.new(:client)
    end

    require 'siilar/client/tracks'

    class TracksService < ClientService
      include Client::Tracks
    end

    require 'siilar/client/search'

    class SearchService < ClientService
      include Client::Search
    end

    require 'siilar/client/tags'

    class TagsService < ClientService
      include Client::Tags
    end
  end
end
