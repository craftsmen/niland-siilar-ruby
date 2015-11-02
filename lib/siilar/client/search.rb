module Siilar
  class Client
    module Search

      # Search for a track
      #
      # @see http://api.siilar.com/1.0/doc/search-and-analyze#search
      def similar(query = {})
        options = { query: query }
        response = client.get('1.0/search', options)

        response.map { |r| Struct::Track.new(r) }
      end

      # Search for a track from external ids
      #
      # @see http://api.siilar.com/1.0/doc/search-and-analyze#search-from-external
      def similar_from_external(query = {})
        options = { query: query }
        response = client.get('1.0/search-from-external', options)

        response.map { |r| Struct::Track.new(r) }
      end

      # Search for similar tracks from query
      #
      # @see https://api.niland.io/1.0/doc/search-and-analyze#search-from-any
      def similar_from_any(query = {})
        options = { query: query }
        response = client.get('1.0/search-from-any', options)

        response.map { |r| Struct::Track.new(r) }
      end
    end
  end
end
