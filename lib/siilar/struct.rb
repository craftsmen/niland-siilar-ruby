module Siilar
  module Struct

    class Base
      def initialize(attributes = {})
        attributes.each do |key, value|
          m = "#{key}=".to_sym
          self.send(m, value) if self.respond_to?(m)
        end
      end
    end
  end
end

require 'siilar/struct/track'
require 'siilar/struct/album'
require 'siilar/struct/artist'
require 'siilar/struct/tag'
require 'siilar/struct/tag_collection'
