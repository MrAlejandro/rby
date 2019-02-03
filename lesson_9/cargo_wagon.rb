class CargoWagon < Wagon
  attr_reader :reserved_volume

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

  def free_volume
    @volume - @reserved_volume
  end

  def to_str
    "Cargo wagon. Volume: #{@volume}, "\
    "reserved: #{@reserved_volume.round(2)}, free: #{free_volume.round(2)}."
  end

  protected

  def validate
    super
    raise 'The wagon volume must be greater than zero.' unless @volume.positive?
  end
end
