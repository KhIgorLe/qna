class Services::Search
  TYPES = %w[Question Answer User Comment].freeze

  def self.search_by(query, type = nil)
    return [] if query.blank?

    query = Riddle::Query.escape(query)

    return type.constantize.search(query) if TYPES.include?(type)

    ThinkingSphinx.search(query)
  end
end
