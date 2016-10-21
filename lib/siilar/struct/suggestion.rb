module Siilar
  module Struct

    class Suggestion < Base
      attr_accessor :similar_artists, :similar_tracks, :artists, :albums
  
      def tags 
        @tags ||= []
      end

      def tags=(attrs)
        if attrs
          @tags = attrs.map { |tag| Struct::Tag.new(tag) }
        end
      end

      def tracks
        @tracks ||= []
      end

      def tracks=(attrs)
        if attrs
          @tracks = attrs.map { |track| Struct::Track.new(track) }
        end
      end
    end
  end
end
