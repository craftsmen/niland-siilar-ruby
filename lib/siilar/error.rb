module Siilar
  class Error < StandardError
  end

  class RequestError < Error
    attr_reader :response

    def initialize(response)
      @response = response
      super("#{response.code}")
    end
  end

  class NotFoundError < RequestError
  end

  class AuthenticationError < Error
  end

  class AuthenticationFailed < AuthenticationError
  end
end
