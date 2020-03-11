require 'pry'
require 'pry-nav'
require_relative 'spec_helper'

RSpec.describe 'End To End Suite' do
  describe "full scenarios" do
    let(:commands) do
      [
          "create_parking_lot 6\n",
          "park KA-01-HH-1234 White\n",
          "park KA-01-HH-9999 White\n",
          "park KA-01-BB-0001 Black\n",
          "park KA-01-HH-7777 Red\n",
          "park KA-01-HH-2701 Blue\n",
          "park KA-01-HH-3141 Black\n",
          "leave 4\n",
          "status\n",
          "park KA-01-P-333 White\n",
          "park DL-12-AA-9999 White\n",
          "registration_numbers_for_cars_with_colour White\n",
          "slot_numbers_for_cars_with_colour White\n",
          "slot_number_for_registration_number KA-01-HH-3141\n",
          "slot_number_for_registration_number MH-04-AY-1111\n"
      ]
    end

    let(:expected) do
      [   "Created a parking lot with 6 slots\n","Allocated slot number: 1\n","Allocated slot number: 2\n","Allocated slot number: 3\n","Allocated slot number: 4\n","Allocated slot number: 5\n","Allocated slot number: 6\n","Slot number 4 is free\n","Slot No.\tRegistration No\t Color\n1\t\t KA-01-HH-1234\t White\n2\t\t KA-01-HH-9999\t White\n3\t\t KA-01-BB-0001\t Black\n5\t\t KA-01-HH-2701\t Blue\n6\t\t KA-01-HH-3141\t Black\n","Allocated slot number: 4\n","Sorry, parking lot is full\n","KA-01-HH-1234, KA-01-HH-9999, KA-01-P-333\n","1, 2, 4\n","6\n","Not found\n"
      ]
    end

    it "input from file" do
      pty = PTY.spawn("bin/parking_lot #{File.join(File.dirname(__FILE__), '..', 'fixtures', 'file_input.txt')}")
      print 'Testing file input: '
      expect(fetch_stdout(pty)).to eql(expected.join(''))
    end

    it "interactive input" do
      pty = PTY.spawn("bin/parking_lot")
      print 'Testing interactive input: '
      commands.each_with_index do |cmd, index|
        print cmd
        run_command(pty, cmd)
        expect(fetch_stdout(pty)).to end_with(expected[index])
      end
    end
  end
end
