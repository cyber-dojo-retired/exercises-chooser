# frozen_string_literal: true
require_relative 'test_base'

class ResponseErrorTest < TestBase

  def self.id58_prefix
    'q7E'
  end

  # - - - - - - - - - - - - - - - - -

  test 'F8k', %w(
  |any http-service call
  |is a 500 error
  |when response's json.body is not JSON
  ) do
    assert_get_500('/group_choose', _not_json='xxxx')
  end

  # - - - - - - - - - - - - - - - - -

  test 'F9k', %w(
  |any http-service call
  |is a 500 error
  |when response's json.body is not JSON-Hash
  ) do
    assert_get_500('/kata_choose', _not_json_hash='[]')
  end

  # - - - - - - - - - - - - - - - - -

  test 'F9p', %w(
  |any http-serice call
  |is a 500 error
  |when response's json.body has embedded exception
  ) do
    assert_get_500('/kata_choose', _exception='{"exception":"xxx"}')
  end

  # - - - - - - - - - - - - - - - - -

  test 'F9q', %w(
  |any http-servive call
  |is a 500 error
  |when response's json.body has no key for method
  ) do
    assert_get_500('/kata_choose', _no_key='{}')
  end

  private

  def assert_get_500(path, stub)
    stub_custom_start_points_http(stub)
    _stdout,stderr = capture_stdout_stderr {
      get path
    }
    assert status?(500), status
    assert_equal '', stderr, :stderr_is_empty
    #stdout
  end

  def stub_custom_start_points_http(body)
    externals.instance_exec {
      @custom_start_points_http = HttpAdapterStub.new(body)
    }
  end

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
  end

end
