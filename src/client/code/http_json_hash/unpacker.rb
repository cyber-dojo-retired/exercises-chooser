# frozen_string_literal: true
require 'json'

module HttpJsonHash
  class Unpacker

    def initialize(name, requester)
      @name = name
      @requester = requester
    end

    # - - - - - - - - - - - - - - - - - - - - -

    def get(path, args)
      response = @requester.get(path, args)
      unpacked(response.body, path.to_s, args)
    end

    private

    def unpacked(body, path, args)
      json = JSON.parse!(body)
      json[path]
    end

  end
end
