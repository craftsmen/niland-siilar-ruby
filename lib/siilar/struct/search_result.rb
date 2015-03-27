module Siilar
  module Struct

    class SearchResult < Base
      attr_accessor :id, :hash, :title, :popularity, :duration, :external_id, :isrc, :waveform_url

      def album
        @album ||= {}
      end

      def album=(attrs)
        @album = Struct::Album.new(attrs)
      end

      def artist
        @artist ||= {}
      end

      def artist=(attrs)
        @artist = Struct::Artist.new(attrs)
      end
    end
  end
end
