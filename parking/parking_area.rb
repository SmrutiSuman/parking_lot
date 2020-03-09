require 'pry'

require_relative './vehicle'
require_relative './slot'

class ParkingArea
  attr_accessor :slots

  def initialize(no_of_slots)
    @slots = []
    no_of_slots.to_i.times do |index|
      @slots[index] = Slot.new(index + 1)
    end
    puts "Created a parking lot with #{no_of_slots} slots\n"
  end

  def park(registration_number, color)
    available_slot = self.find_available_slot
    if available_slot
      available_slot.park(registration_number, color)
    else
      puts "Sorry, parking lot is full\n"
    end
  end

  def find_available_slot
    @slots.find do |slot|
      slot.available?
    end
  end

  def leave(slot_no)
    slot_no = slot_no.to_i
    if slot_no > 0 && slot_no <= slots.length
      slots[slot_no - 1].make_empty
      puts "Slot number #{slot_no} is free\n"
    else
      puts "Invalid slot number"
    end
  end

  def status
    puts "Slot No.\tRegistration No\t Color\n"
    @slots.each do | slot |
      puts "#{ slot.id }\t\t #{ slot.vehicle_registration_number }\t #{ slot.vehicle_color }\n" unless (slot.available?)
    end
  end

  def registration_numbers_for_cars_with_colour (color)
    cars = @slots.collect do |slot|
            slot.vehicle_registration_number if slot.vehicle_color == color
          end
    print_result cars
  end

  def slot_numbers_for_cars_with_colour (color)
    cars = @slots.collect do |slot|
            slot.id if slot.vehicle_color == color
          end
    print_result cars
  end

  def slot_number_for_registration_number (vehicle_number)
    print_result ([] << @slots.find {|slot| slot.vehicle_registration_number == vehicle_number })
  end

  def print_result cars
    if cars.compact.empty?
      puts "No Cars Found"
    else
      puts cars.compact.join(', ')
    end
  end
end