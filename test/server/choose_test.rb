# frozen_string_literal: true
require_relative 'test_base'

class ChooseTest < TestBase

  def self.id58_prefix
    'a73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |GET/group_choose
  |offers all display_names
  |ready to create a group
  |when custom_start_points is online
  ) do
    get '/group_choose'
    assert status?(200), status
    html = last_response.body
    assert heading(html).include?('our'), html
    refute heading(html).include?('my'), html
    display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '19w', %w(
  |GET/kata_choose
  |offers all display_names
  |ready to create a kata
  |when custom_start_points is online
  ) do
    get '/kata_choose'
    assert status?(200), status
    html = last_response.body
    assert heading(html).include?('my'), html
    refute heading(html).include?('our'), html
    display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  private

  def heading(html)
    # (.*?) for non-greedy match
    # /m for . matching newlines
    html.match(/<div id="heading">(.*?)<\/div>/m)[1]
  end

  def div_for(display_name)
    # eg cater for "C++ Countdown, Round 1"
    plain_display_name = Regexp.quote(display_name)
    /<div class="display-name">\s*#{plain_display_name}\s*<\/div>/
  end

end
