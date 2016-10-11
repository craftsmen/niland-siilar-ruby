module Siilar
  module Struct

    class Tag < Base
      attr_accessor :id, :title, :synonyms

      def tag_collection 
        @tag_collection ||= []
      end
      
      def tag_collection=(attrs)
        if attrs
          @tag_collection = attrs.map { |tag_collection| Struct::TagCollection.new(tag_collection) }
        end
      end
    end
  end
end
