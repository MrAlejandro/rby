class Wagon
  TYPES = %i[cargo passenger].freeze

  def initialize(type)
    @type = type
    validate
  end

  def valid?
    validate
    true
  rescue StandardError
    false
  end

  def of_type?(type)
    @type == type
  end

  def to_str
    @type
  end

  protected

  def validate
    unless TYPES.include?(@type)
      raise 'Invalid wagon type provided.'\
            "Allowed types: #{TYPES.join(', ')}."
    end
  end
end
