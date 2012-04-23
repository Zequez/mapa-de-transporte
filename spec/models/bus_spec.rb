require 'spec_helper'

describe Bus do
  before :each do
    @bus = Bus.new
  end

  context "routes" do
    it "should have routes" do
      @bus.departure_route = Route.new
      @bus.return_route = Route.new
    end

    it "should create the routes on create" do
      @bus = Bus.create!
      @bus.departure_route.class.should eq Route
      @bus.return_route.class.should eq Route
    end

    it "should update the routes through attributes" do
      @bus = Bus.create!
      @bus.update_attributes! departure_route_attributes: {
        checkpoints_attributes: [
          {latitude: 123, longitude: 321, number: 1},
          {latitude: 456, longitude: 654, number: 2}
        ]
      }, return_route_attributes: {
        checkpoints_attributes: [
          {latitude: 789, longitude: 987, number: 1},
          {latitude: 890, longitude: 98, number: 2}
        ]
      }
    end
  end
end
