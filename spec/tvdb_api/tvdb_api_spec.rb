require 'spec_helper.rb'
require 'vcr'
require 'support/vcr_setup.rb'

RSpec.describe TvdbApi do
  describe "#initialize" do

    context "given blank api key" do
      it "returns Argumentorror" do
        expect { TvdbApi.new("") }.to raise_error(ArgumentError)
        expect { TvdbApi.new(nil) }.to raise_error(ArgumentError)
        expect { TvdbApi.new(" ") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#load_token" do

    context "given an unathourized key" do
      it "returns UnauthorizedError" do
        tvdb_api = TvdbApi.new("invalid_key")

        expect {tvdb_api.load_token}.to raise_error(TheTvdbApi::UnauthorizedError)
      end
    end

    context "given a valid key" do
      it "loads token" do
        tvdb_api = TvdbApi.new("correct_key")

        VCR.use_cassette('valid_token') do
          tvdb_api.load_token
          expect(tvdb_api.token).to be_present
        end
      end
    end
  end

end
