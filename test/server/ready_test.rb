# frozen_string_literal: true
require_relative 'test_base'
require 'ostruct'

class ReadyTest < TestBase

  def self.id58_prefix
    'a86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( ready when exercises-start-points is ready ) do
    get '/ready'
    assert last_response.ok?
    assert_equal '{"ready?":true}', last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  test '15E',
  %w( not ready when exercises-start-points is not ready ) do
    externals.instance_exec {
      @exercises_start_points = OpenStruct.new(ready?:false)
    }
    get '/ready'
    assert last_response.ok?
    assert_equal '{"ready?":false}', last_response.body
  end

end
