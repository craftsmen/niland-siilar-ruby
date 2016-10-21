module Siilar
  module Struct

    class User < Base
      attr_accessor :reference, :birthdate, :gender, :country, :city
    end
  end
end
