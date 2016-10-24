module Siilar
  class Client
    module Search

      # Search for a track
      #
      # @see https://api.niland.io/2.0/doc/tracks#search-for-tracks
      def tracks(query = {})
        options = { query: query }
        response = client.get('tracks/search', options)

        response['data'].map { |r| Struct::Track.new(r) }
      end

      # Search for a track from external ids
      #
      # @see http://api.niland.io/2.0/doc/search-and-analyze#search-from-external
      def suggestions(query = {})
        options = { query: query }
        response = client.get('suggestions', options)

        Struct::Suggestion.new(response)
      end
    end
  end
end
