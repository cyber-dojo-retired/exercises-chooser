# frozen_string_literal: true
require_relative 'test_base'

class RequestErrorTest < TestBase

  def self.id58_prefix
    'q7D'
  end

  # - - - - - - - - - - - - - - - - -

  test 'Je4', %w(
  |POST with non-JSON in request.body
  |is 500 error
  ) do
    path = 'kata_create'
    not_json = 'xxx'
    _stdout,_stderr = capture_stdout_stderr {
      post '/'+path, not_json, JSON_REQUEST_HEADERS
    }
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'Je5', %w(
  |POST with non-JSON-Hash in request.body
  |is 500 error
  ) do
    path = 'kata_create'
    not_json = '[]'
    _stdout,_stderr = capture_stdout_stderr {
      post '/'+path, not_json, JSON_REQUEST_HEADERS
    }
    assert status?(500), status
  end

end
