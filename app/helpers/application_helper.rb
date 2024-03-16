module ApplicationHelper
  def format_nil_as_dashes(value)
    value.nil? ? "--".html_safe : value
  end
end
