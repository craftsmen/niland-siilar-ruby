module Siilar
  module Struct

    class TagCollection < Base
      attr_accessor :id, :name, :description

      def tags
        @tags ||= []
      end

      def tags=(attrs)
        if attrs
          @tags = attrs.map { |tag| Struct::Tag.new(tag) }
        end
      end
    end
  end
end
