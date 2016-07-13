class Search
  TYPES = %w(all questions answers comments users).freeze

  def self.find(query, type)
    query = Riddle::Query.escape(query)
    return [] unless TYPES.include? type
    type == 'all' ? ThinkingSphinx.search(query) : type.singularize.classify.constantize.search(query)
  end
end
