module Siilar
  module Struct

    class User < Base
      attr_accessor :external_id, :birthdate, :gender, :country, :city
    end
  end
end
