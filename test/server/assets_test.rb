# frozen_string_literal: true
require_relative 'test_base'

class AssetsTest < TestBase

  def self.id58_prefix
    'Q3p'
  end

  # - - - - - - - - - - - - - - - - -

  test '2Je', %w(
  |GET /assets/app.css is served
  ) do
    get '/assets/app.css'
    assert status?(200), status
    assert css_content?, content_type
  end

end
