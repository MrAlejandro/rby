class Wagon
  def initialize(type)
    @type = type
  end

  def is_of_type?(type)
    @type == type
  end
end
