require_relative '../../parking/slot'

RSpec.describe 'Slot' do

  it "create slot with a given number" do
    slot = Slot.new(1)
    expect(slot.id).to eq(1)
  end

  it 'if wrong number arguments are given' do
    expect { Slot.new }.to raise_error(ArgumentError)
  end

  it 'parks vehicle' do
    slot = Slot.new(1)
    slot.park("KA-IN_9899", "White")
    expect(slot.vehicle.color).to eq('White')
  end

  it "raises error while trying to park a vehicle in parked slot" do
    slot = Slot.new(1)
    slot.park("KA-IN_9822", "Black")
    expect { slot.park("KA-IN_9899", "White") }.to raise_error("Sorry, Car already parked")
  end

end