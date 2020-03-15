# frozen_string_literal: true
require_relative 'id_pather'
require_relative 'test_base'
require_src 'external_http'
require_src 'external_saver'
require 'json'

class CreateTest < TestBase

  def self.id58_prefix
    'xRa'
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5D', %w(
  |PATH /custom-chooser/group_choose
  |shows custom display-names
  |selecting one
  |clicking [ok] button
  |redirects to /kata/group/:ID
  ) do
    visit('/custom-chooser/group_choose')
    display_name = 'Java Countdown, Round 1'
    find('div.display-name', text:display_name).click
    find('#ok').click
    assert %r"/kata/group/(?<id>.*)" =~ current_path, current_path
    assert group_exists?(id), "id:#{id}:"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5E', %w(
  |PATH /custom-chooser/kata_choose shows
  |custom display-names
  |selecting one
  |clicking [ok] button
  |redirects to /kata/edit/:ID
  ) do
    visit('/custom-chooser/kata_choose')
    display_name = 'Java Countdown, Round 1'
    find('div.display-name', text:display_name).click
    find('#ok').click
    assert %r"/kata/edit/(?<id>.*)" =~ current_path, current_path
    assert kata_exists?(id), "id:#{id}:"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
  end

  private

  include IdPather

  def group_exists?(id)
    saver.exists?(group_id_path(id))
  end

  def kata_exists?(id)
    saver.exists?(kata_id_path(id))
  end

  # - - - - - - - - - - - - - - - - - - - -

  def group_manifest(id)
    JSON::parse!(saver.read("#{group_id_path(id)}/manifest.json"))
  end

  def kata_manifest(id)
    JSON::parse!(saver.read("#{kata_id_path(id)}/manifest.json"))
  end

  # - - - - - - - - - - - - - - - - - - - -

  def saver
    ExternalSaver.new(saver_http)
  end

  def saver_http
    ExternalHttp.new
  end

end
