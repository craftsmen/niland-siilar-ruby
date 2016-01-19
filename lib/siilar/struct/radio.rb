module Siilar
  module Struct

    class Radio < Base
      attr_accessor :id
      def current_tracks 
        @current_tracks ||= []
      end
      
      def current_tracks=(attrs)
        if attrs
          @current_tracks = attrs.map { |track| Struct::Track.new(track) }
        end
      end

      def seeds
        @seeds ||= []
      end

      def seeds=(attrs)
        if attrs
          @seeds = attrs.map { |seed| Struct::Track.new(seed) }
        end
      end
      
      def tags 
        @tags ||= []
      end

      def tags=(attrs)
        if attrs
          @tags = attrs.map { |tag| Struct::Tag.new(tag) }
        end
      end

      def user
        @tags ||= {}
      end

      def user=(attrs)
        if attrs
          @user = Struct::User.new(attrs)
        end
      end
    end
  end
end
