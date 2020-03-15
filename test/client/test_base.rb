# frozen_string_literal: true
require_relative '../id58_test_base'
require 'capybara/minitest'

class TestBase < Id58TestBase

  include Capybara::DSL
  include Capybara::Minitest::Assertions

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app,
      browser: :remote,
      url: 'http://selenium:4444/wd/hub',
      desired_capabilities: :firefox
    )
  end

  def setup
    Capybara.app_host = 'http://nginx:80'
    Capybara.javascript_driver = :selenium
    Capybara.current_driver    = :selenium
    Capybara.run_server = false
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.app_host = nil
  end

  # - - - - - - - - - - - - - - - - - - -

  def initialize(arg)
    super(arg)
  end

end
