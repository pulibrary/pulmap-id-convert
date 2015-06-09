require 'spec_helper'
require 'byebug'

describe API do
  include Rack::Test::Methods

  def app
    API
  end

  describe 'endpoints' do
    let(:item) { FactoryGirl.create(:item) }

    context "GET /items" do
      it "returns an array of items" do
        get "/items"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to be_a Array
      end
    end

    context "GET /arks" do
      it "returns an array of arks" do
        get "/arks"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to be_a Array
      end
    end

    context "GET /arks/:ark" do
      it "should return an item by ark" do
        get "/arks/#{item.ark}"
        expect(last_response.body).to eq item.to_hash.to_json
      end
    end

    context "GET /guids" do
      it "returns an array of guids" do
        get "/guids"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to be_a Array
      end
    end

    context "GET /guids/:guid" do
      it "should return an item by guid" do
        get "/guids/#{item.guid}"
        expect(last_response.body).to eq item.to_hash.to_json
      end
    end

    context "GET /images" do
      it "returns an array of images ids" do
        get "/images"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to be_a Array
      end
    end

    context "GET /images/:image" do
      it "should return an item by image id" do
        get "/images/#{item.image}"
        expect(last_response.body).to eq item.to_hash.to_json
      end
    end
  end
end