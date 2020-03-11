require 'pry'
require 'pry-nav'
require_relative 'spec_helper'
require_relative '../../parking/parking_area'

RSpec.describe 'Parking Lot' do
  let(:pty) { PTY.spawn('bin/parking_lot') }

  before(:each) do
    run_command(pty, "create_parking_lot 3\n")
  end

  it "can create a parking lot", :sample => true do
    expect(fetch_stdout(pty)).to end_with("Created a parking lot with 3 slots\n")
  end

  it "can park a car" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    expect(fetch_stdout(pty)).to end_with("Allocated slot number: 1\n")
  end
  
  it "can unpark a car" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("Slot number 1 is free\n")
  end
  
  it "can report status" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "status\n")
    expect(fetch_stdout(pty)).to eql("Allocated slot number: 2\npark KA-01-HH-9999 White\nAllocated slot number: 3\nstatus\nSlot No.\tRegistration No\t Color\n1\t\t KA-01-HH-1234\t White\n2\t\t KA-01-HH-3141\t Black\n3\t\t KA-01-HH-9999\t White\n")
  end

  context 'get list of cars of given input' do
    before(:each) do
      run_command(pty, "park KA-01-HH-3141 Black\n")
      run_command(pty, "park KA-01-HH-1234 White\n")
      run_command(pty, "park KA-01-HH-9999 White\n")
    end

    it "can get registration numbers of cars with a given color" do
      run_command(pty, "registration_numbers_for_cars_with_colour White\n")
      expect(fetch_stdout(pty)).to end_with("KA-01-HH-1234, KA-01-HH-9999\n")
    end

    it "can get slot numbers with cars with given color" do
      run_command(pty, "slot_numbers_for_cars_with_colour White\n")
      expect(fetch_stdout(pty)).to end_with("2, 3\n")
    end

    it "can get slot number of car with its registration number" do
      run_command(pty, "slot_number_for_registration_number KA-01-HH-9999\n")
      expect(fetch_stdout(pty)).to end_with("3\n")
    end
  end

  context 'raise errors' do

    it 'if wrong number arguments are given' do
      expect { ParkingArea.new }.to raise_error(ArgumentError)
    end

    it "if duplicate vehicle parked" do
      parking_lot = ParkingArea.new('3')
      parking_lot.park('KA-01-HH-9999', 'White')
      parking_lot.park('KA-01-HH-4756', 'Red')
      expect { parking_lot.park('KA-01-HH-9999', 'White') }.to raise_error("Can not park duplicate vehicle")
    end

    it 'if parking lot is full' do
      parking_lot = ParkingArea.new('1')
      parking_lot.park('KA-01-HH-9999', 'White')
      expect do
          parking_lot.park('KA-01-HH-9900', 'Black')
      end.to output("Sorry, parking lot is full\n").to_stdout
    end

    it 'if invalid slot number gets empty ' do
      parking_lot = ParkingArea.new('1')
      parking_lot.park('KA-01-HH-9999', 'Black')
      expect do
          parking_lot.leave(10)
      end.to output("Invalid slot number\n").to_stdout
    end

  end

end
