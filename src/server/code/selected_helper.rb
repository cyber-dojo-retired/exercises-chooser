# frozen_string_literal: true
module SelectedHelper

  def selected(visible_files)
    if visible_files.has_key?('readme.txt')
      visible_files['readme.txt']['content']
    else
      visible_files.max{ |(_,lhs),(_,rhs)|
        lhs['content'].size <=> rhs['content'].size
      }[1]['content']
    end
  end

end
