require 'spec_helper'

describe FeedbacksController do

  before(:each) do
    @city = City.create name: "Ciudad"
  end

  def valid_request(extend = {})
    {
      name: "Zequez",
      email: "zequez@gmail.com",
      message: "Hola!",
      city_id: @city.id
    }.merge extend
  end

  describe "/feedbacks" do
    describe "POST" do

      context "Valid feedback" do
        before(:each) do
          post "/feedbacks", feedback: valid_request
        end

        it "should respond succefully" do
          response.status.should eql 200
        end

        it "should say thank you" do
          response.body.should match /gracias/i
        end
      end

      context "Invalid feedback" do
        before(:each) do
          post "/feedbacks", feedback: valid_request(email: "bad_email")
        end

        it "should say that there is an error" do
          response.body.should match /error/i
        end

        it "should show a form fully filled" do
          response.body.should match /Zequez/
          response.body.should match /bad_email/
          response.body.should match /Hola!/
        end
      end
    end
  end
end
