# frozen_string_literal: true
module SelectedHelper

  def selected(visible_files)
    if visible_files.has_key?('readme.txt')
      visible_files['readme.txt']['content']
    else
      visible_files.max{ |lhs,rhs|
        lhs[1]['content'].size <=> rhs[1]['content'].size
      }[1]['content']
    end
  end

end
