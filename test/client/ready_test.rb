# frozen_string_literal: true
require_relative 'test_base'
require 'ostruct'

class ReadyTest < TestBase

  def self.id58_prefix
    'a86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( its ready ) do
    get '/ready'
    assert last_response.ok?
    assert_equal '{"ready?":true}', last_response.body
  end

end
