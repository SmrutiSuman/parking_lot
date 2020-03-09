require_relative './vehicle'

class Slot

  attr_accessor :id, :vehicle

  def initialize (id)
    @id = id.to_i
  end

  def park(registration_number, color)
    if self.vehicle
      raise "Sorry, Car already parked"
    else
      puts "Allocated slot number: #{ self.id }"
      self.vehicle = ::Vehicle.new(registration_number, color)
    end
  end

  def make_empty
    self.vehicle = nil
  end

  def available?
    self.vehicle == nil
  end

  def vehicle_registration_number
    vehicle.registration_number if vehicle
  end

  def vehicle_color
    vehicle.color if vehicle
  end

end