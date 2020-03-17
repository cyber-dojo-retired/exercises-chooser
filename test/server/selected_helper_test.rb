# frozen_string_literal: true
require_relative 'test_base'
require_src 'selected_helper'

class LargestTest < TestBase

  def self.id58_prefix
    '5FF'
  end

  include SelectedHelper

  # - - - - - - - - - - - - - - - - - - -

  test '841', %w(
  select readme.txt content when readme.txt present
  even if not largest content
  ) do
    expected = 'x' * 34
    visible_files = {
      'readme.txt' => {
        'content' => expected,
      },
      'larger.txt' => {
        'content' => 'y'*142
      }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '842', %w(
  selected content when single visible_file
  ) do
    expected = 'x' * 34
    visible_files = {
      'instructions' => {
        'content' => expected
      }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '843', %w(
  select largest content when more than one visible_file
  ) do
    expected = 'x' * 34
    visible_files = {
      'smaller' => {
        'content' => 'y' * 33,
      },
      'larger.txt' => {
        'content' => expected
      }
    }
    assert_equal expected, selected(visible_files)
  end

end
