class CargoWagon < Wagon
  def initialize(volume)
    @volume = volume.to_f
    @reserved_volume = 0
    super(:cargo)
  end

  def reserve_volume(volume)
    volume = volume.to_f
    can_reserve = volume < free_volume && volume.positive?
    @reserved_volume += volume if can_reserve
  end

  def reserved_volume
    @reserved_volume
  end

  def free_volume
    @volume - @reserved_volume
  end

  protected

  def validate
    raise "The wagon volume must be greater than zero." unless @volume.positive?
    super()
  end
end
