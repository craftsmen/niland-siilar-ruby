require 'siilar/extra'
require 'siilar/struct'
require 'siilar/client/clients'

module Siilar
  class Client
    attr_accessor :api_endpoint, :api_key, :user_agent, :requests_timeout

    def initialize(options = {})
      defaults = Siilar::Default.options

      Siilar::Default.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || defaults[key])
      end

      @services = {}
    end

    def get(path, options = {})
      execute :get, path, options
    end

    def post(path, options = {})
      execute :post, path, options
    end

    def patch(path, options = {})
      execute :patch, path, options
    end

    def delete(path, options = {})
      execute :delete, path, options
    end

    def execute(method, path, data, options = {})
      response = request(method, path, data, options)

      case response.code
      when 200..299
        response
      when 401
        raise AuthenticationFailed, response['message']
      when 404
        raise NotFoundError.new(response)
      else
        raise RequestError.new(response)
      end
    end

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query] = data.delete(:query) if data.key?(:query)
        options[:headers] = data.delete(:headers) if data.key?(:headers)
      end
      if !data.empty?
        options[:body] = data.to_json
      end
      HTTParty.send(method, api_endpoint + path, Extra.deep_merge!(base_options, options))
    end

    def api_endpoint
      File.join(@api_endpoint, '')
    end

    private

    def base_options
      options = {
        format: :json,
        headers: {
          'Accept' => 'application/json',
          'Content-type' => 'application/json',
          'User-Agent' => user_agent
        }
      }

      if requests_timeout
        options.merge!(timeout: requests_timeout)
      end

      if api_key
        options.merge!(query: { key: api_key })
      else
        raise Error, 'An API key is required for all API requests.'
      end

      options
    end
  end
end
