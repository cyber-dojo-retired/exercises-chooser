# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'capture_stdout_stderr'
require_src 'app'
require_src 'externals'

class TestBase < Id58TestBase
  include CaptureStdoutStderr
  include Rack::Test::Methods # [1]

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def app
    App.new(externals) # [1]
  end

  def display_names
    manifests = exercises_start_points.manifests
    manifests.keys.sort
  end

  def exercises_start_points
    externals.exercises_start_points
  end

  # - - - - - - - - - - - - - - -

  def status?(expected)
    status === expected
  end

  def status
    last_response.status
  end

  # - - - - - - - - - - - - - - -

  def css_content?
    content_type === 'text/css; charset=utf-8'
  end

  def content_type
    last_response.headers['Content-Type']
  end

  # - - - - - - - - - - - - - - -

  def escape_html(text)
    Rack::Utils.escape_html(text)
  end

end
