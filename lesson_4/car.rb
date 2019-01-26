class Car
  # тут не наберется логака на отдельный класс
  def initialize(type)
    @type = type
  end

  def is_of_type?(type)
    @type == type
  end
end