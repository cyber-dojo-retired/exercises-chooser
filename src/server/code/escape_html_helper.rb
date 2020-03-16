# frozen_string_literal: true
module EscapeHtmlHelper

  def h(text)
    Rack::Utils.escape_html(text)
  end

end
