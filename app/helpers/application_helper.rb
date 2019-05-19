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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
