# encoding: utf-8
require 'spec_helper'

describe SellLocationsSuggestion do
  context "Validation" do
    before :each do
      #@sell = City.create name: "Ciudad"

      @sell = SellLocation.create  address: "España 3444",
                                   name: "Mi casa",
                                   info: "Es un lugar mágico y lleno de fantasías.",
                                   lat: -57,
                                   lng: -32,
                                   visibility: true,
                                   card_selling: true,
                                   card_reloading: true,
                                   ticket_selling: false

      @sell_sugg = SellLocationsSuggestion.new user_email: "zequez@gmail.com",
                                               user_name: "Zequez",
                                               address: "España 3182",
                                               name: "Tu casa",
                                               info: "Es un lugar.",
                                               lat: -52,
                                               lng: -30,
                                               visibility: true,
                                               sell_location_id: @sell.id,
                                               card_selling: true,
                                               card_reloading: true, 
                                               ticket_selling: false
    end

    describe "#user_email" do
      it "is the same validation as feedback, don't test this."
    end

    describe "#user_name" do
      it "is the same validation as feedback, don't test this."
    end

    describe "#address" do
      it "should allow a alphanumeric characters, spaces, colons, etc" do
        @sell_sugg.address = "España 3444, Mar del Plata, Heh's \"dumb\" & real #1°"
        @sell_sugg.should be_valid
      end

      it "should not allow empty" do
        @sell_sugg.address = ''
        @sell_sugg.should_not be_valid
      end
    end

    describe "#name" do
      it "should allow empty" do
        @sell_sugg.name = ''
        @sell_sugg.should be_valid
      end

      it "should allow anything" do
        @sell_sugg.name = 'dsaklfsdñajf $;#"ÑL;F:_SDF;"'
        @sell_sugg.should be_valid
      end
    end

    describe "#info" do
      it "should allow empty" do
        @sell_sugg.info = ''
        @sell_sugg.should be_valid
      end

      it "should allow anything" do
        @sell_sugg.info = 'dsaklfsdñajf $;#"ÑL;F:_SDF;"'
        @sell_sugg.should be_valid
      end
    end

    describe "#lat" do
      it "should be converted to 0 if it's not a number" do
        @sell_sugg.lat = 'dlasdas'
        @sell_sugg.lat.should eq 0
      end
      
      it "should be assigned properly" do
        @sell_sugg.lat = 123
        @sell_sugg.lat.should eq 123
      end
      
      it "should be 0 if blank assigned" do
        @sell_sugg.lat = ''
        @sell_sugg.save!
        @sell_sugg.reload
        @sell_sugg.lat.should eq 0
      end
    end

    describe "#lng" do
      it "should be converted to 0 if it's not a number" do
        @sell_sugg.lng = 'dlasdas'
        @sell_sugg.lng.should eq 0
      end

      it "should be assigned properly" do
        @sell_sugg.lng = 123
        @sell_sugg.lng.should eq 123
      end

      it "should be 0 if blank assigned" do
        @sell_sugg.lng = ''
        @sell_sugg.save!
        @sell_sugg.reload
        @sell_sugg.lng.should eq 0
      end
    end

    describe "#sell_location_id" do
      it "is valid blank" do
        @sell_sugg.sell_location_id = nil
        @sell_sugg.should be_valid
      end

      it "is valid for a non existant sell_location" do
        @sell_sugg.sell_location_id = -1
        @sell_sugg.should be_valid
      end

      it "is valid for an existing sell_location assigning it by #sell_location_id" do
        @sell_sugg.sell_location_id = @sell.id
        @sell_sugg.should be_valid
      end

      it "is valid for an existing sell_location" do
        @sell_sugg.sell_location = @sell
        @sell_sugg.should be_valid
      end
    end
  end
end
