# frozen_string_literal: true
require_relative 'chooser.rb'
require_relative 'app_base'

class App < AppBase

  # - - - - - - - - - - - - - - - - - - - - - -
  # ctor

  def initialize(externals)
    super()
    @externals = externals
  end

  def target
    Chooser.new(@externals)
  end

  get_probe(:alive?) # curl/k8s
  get_probe(:ready?) # curl/k8s
  get_json(:sha)     # identity

end
