module Siilar
  class Client

    def radios
      @services[:radios] ||= Client::RadiosService.new(self)
    end

    def search
      @services[:search] ||= Client::SearchService.new(self)
    end

    def tags
      @services[:tags] ||= Client::TagsService.new(self)
    end

    def tracks
      @services[:tracks] ||= Client::TracksService.new(self)
    end

    def users
      @services[:users] ||= Client::UsersService.new(self)
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

    require 'siilar/client/users'

    class UsersService < ClientService
      include Client::Users
    end

    require 'siilar/client/radios'

    class RadiosService < ClientService
      include Client::Radios
    end
  end
end
