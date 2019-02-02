class Wagon
  TYPES = [:cargo, :passenger]

  def initialize(type)
    @type = type
    validate
  end

  def valid?
    validate
    true
  rescue
    false
  end

  def is_of_type?(type)
    @type == type
  end

  def to_str
    @type
  end

  protected

  def validate
    raise "Invalid wagon type provided. Allowed types: #{TYPES.join(", ")}." unless TYPES.include?(@type)
  end
end
