require 'spec_helper'

describe Feedback do
  context "Validation" do
    before :each do
      @city = City.create name: "Ciudad"
      @feedback = Feedback.new email: "zequez@gmail.com",
                               name: "Zequez",
                               address: "127.0.0.1",
                               message: "Hola. Gracias. Chau.",
                               city: @city
    end

    describe "#email" do
      context "invalid" do
        it "doesn't have an @" do
          @feedback.email = "invalid_email"
          @feedback.should_not be_valid
        end

        it "is not longer than 200" do
          @feedback.email = ("e"*195) + "@g.com"

          @feedback.should_not be_valid
        end
      end

      context "valid" do
        it "is shorter or equal to 200" do
          @feedback.email = ("e"*194) + "@g.com"
          @feedback.should be_valid

        end

        it "is a valid email" do
          @feedback.email = "zequez@gmail.com"
          @feedback.should be_valid
        end

        it "is blank" do
          @feedback.email = ""
          @feedback.should be_valid
        end
      end
    end

    describe "#name" do
      context "invalid" do
        it "is blank" do
          @feedback.name = ""
          @feedback.should_not be_valid
        end

        it "is longer than 200" do
          @feedback.name = "a"*201
          @feedback.should_not be_valid
        end
      end

      context "valid" do
        it "is shorter or equal to 200" do
          @feedback.name = "a"*200
          @feedback.should be_valid
        end

        it "is at least a character long" do
          @feedback.name = "a"
          @feedback.should be_valid
        end
      end
    end

    describe "#message" do
      context "invalid" do
        it "is longer than 500" do
          @feedback.message = "a"*501
          @feedback.should_not be_valid
        end

        it "is blank" do
          @feedback.message = ""
          @feedback.should_not be_valid
        end
      end

      context "valid" do
        it "is shorter or equal to 500" do
          @feedback.message = "a"*500
          @feedback.should be_valid
        end

        it "is at least one character long" do
          @feedback.message = "a"
          @feedback.should be_valid
        end
      end
    end

    describe "#address" do

      context "invalid" do
        it "is in the database" do
          @feedback.address = "127.0.0.1"
          other_feedback = @feedback.dup
          @feedback.save!

          other_feedback.should_not be_valid
        end

        it "is in the database and there have not passed 20 seconds yet" do
          @feedback.address = "127.0.0.1"
          other_feedback = @feedback.dup
          @feedback.save!

          @feedback.created_at -= 19.seconds
          @feedback.save!

          other_feedback.should_not be_valid
        end
      end

      context "valid" do
        it "is not in the database" do
          @feedback.address = "127.0.0.1"
          @feedback.should be_valid
        end

        it "is in the database but 20 seconds have passed" do
          @feedback.address = "127.0.0.1"
          other_feedback = @feedback.dup
          @feedback.save!

          @feedback.created_at -= 20.seconds
          @feedback.save!

          other_feedback.should be_valid
        end
      end
    end

    describe "#city" do
      it "is not valid blank" do
        @feedback.city = nil
        @feedback.should_not be_valid
      end

      it "is not valid for a non existant city" do
        @feedback.city_id = -1
        @feedback.should_not be_valid
      end

      it "is valid for an existing city assigning it by #city_id" do
        @feedback.city_id = City.first.id
        @feedback.should be_valid
      end

      it "is valid for an existing city" do
        @feedback.city = City.first
        @feedback.should be_valid
      end
    end
  end
end
