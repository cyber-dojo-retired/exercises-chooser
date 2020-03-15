# frozen_string_literal: true
require_relative 'test_base'

class ShaTest < TestBase

  def self.id58_prefix
    'de3'
  end

  # - - - - - - - - - - - - - - - - -

  test 'p23',
  %w( sha is 40-char git commit sha ) do
    get '/sha'
    assert last_response.ok?
    sha = JSON.parse!(last_response.body)['sha']
    assert git_sha?(sha), sha
  end

  private

  def git_sha?(s)
    s.instance_of?(String) &&
      s.size === 40 &&
        s.chars.all?{ |ch| is_lo_hex?(ch) }
  end

  def is_lo_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end
