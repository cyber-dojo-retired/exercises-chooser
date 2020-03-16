# frozen_string_literal: true
require_relative 'chooser.rb'
require_relative 'app_base'
require_relative 'escape_html_helper'
require_relative 'selected_helper'

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

  probe_get(:alive?) # curl/k8s
  probe_get(:ready?) # curl/k8s
  probe_get(:sha)    # identity

  # - - - - - - - - - - - - - - - - - - - - - -
  # group

  get '/group_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data
        @next_url = '/languages-chooser/group_choose'
        erb :'group/choose'
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # kata

  get '/kata_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data
        @next_url = '/languages-chooser/kata_choose'
        erb :'kata/choose'
      end
    end
  end

  private

  def set_view_data
    manifests = target.manifests
    @display_names = manifests.keys.sort
    @display_contents = []
    @display_names.each do |name|
      @display_contents << selected(manifests[name]['visible_files'])
    end
  end

  include EscapeHtmlHelper
  include SelectedHelper

end
