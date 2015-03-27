module Siilar
  module Struct

    class Track < Base
      attr_accessor :id, :hash, :title, :popularity, :duration, :external_id, :isrc, :waveform_url

      def album
        @album ||= {}
      end

      def album=(attrs)
        if attrs
          @album = Struct::Album.new(attrs)
        end
      end

      def artist
        @artist ||= {}
      end

      def artist=(attrs)
        if attrs
          @artist = Struct::Artist.new(attrs)
        end
      end
    end
  end
end
