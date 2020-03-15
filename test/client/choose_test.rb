# frozen_string_literal: true
require_relative 'test_base'
require 'uri'

class ChooseTest < TestBase

  def self.id58_prefix
    'xRa'
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5D', %w(
  |PATH /exercises-chooser/group_choose
  |shows exercises display-names
  |selecting one
  |clicking [next] button
  |redirects to /languages-chooser/group_choose?exercise_name=SELECTED
  ) do
    visit('/exercises-chooser/group_choose')
    display_name = 'Calc Stats'
    find('div.display-name', text:display_name).click
    find('button#next').click
    assert %r"/languages-chooser/group_choose\?exercise_name=(?<name>.*)" =~ current_url, current_url
    assert_equal 'Calc%20Stats', name
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5E', %w(
  |PATH /exercises-chooser/kata_choose
  |show exercises display-names
  |selecting one
  |clicking [next] button
  |redirects to /languages-chooser/kata_choose?exercise_name=SELECTED
  ) do
    visit('/exercises-chooser/kata_choose')
    display_name = 'Calc Stats'
    find('div.display-name', text:display_name).click
    find('button#next').click
    assert %r"/languages-chooser/kata_choose\?exercise_name=(?<name>.*)" =~ current_url, current_url
    assert_equal 'Calc%20Stats', name
  end

end
