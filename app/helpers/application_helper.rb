module ApplicationHelper
  def flash_class(key)
    case key
    when 'notice'
      'alert alert-info'
    when 'success'
      'alert alert-success'
    when 'warning', 'alert'
      'alert alert-warning'
    end
  end
end
