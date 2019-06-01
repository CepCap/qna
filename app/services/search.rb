class Services::Search
  TYPES = %w[Question Answer Comment User Global].freeze

  attr_accessor :query, :type

  def initialize(query, type)
    @query = query
    @type = type
  end

  def call
    check_errors
    type == 'Global' ? ThinkingSphinx.search(query) : type.constantize.search(query)
  end

  private

  def check_errors
    unless query.present? && TYPES.include?(type)
      raise StandardError, 'Invalid search attributes'
    end
  end
end
