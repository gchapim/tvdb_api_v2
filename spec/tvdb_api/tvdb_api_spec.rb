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

  describe "#search_series_by_name" do
    subject do
      TvdbApi.new("correct_key")
    end

    before do
      VCR.use_cassette('valid_token') do
        subject.load_token
      end
    end

    context "given a blank name" do
      it "raises ArgumentError" do
        expect { subject.search_series_by_name(' ') }.to raise_error(ArgumentError)
        expect { subject.search_series_by_name(nil) }.to raise_error(ArgumentError)
      end
    end

    context "given an inexistent name" do
      it "returns nil" do
        VCR.use_cassette('search_not_found') do
          expect(subject.search_series_by_name('asjoasij')).to be_nil
        end
      end
    end

    context "given a correct name" do
      it "returns search results" do
        VCR.use_cassette('search_found') do
          search = subject.search_series_by_name("Doctor Who")
          expect(search).to be_present
          expect(search).to be_a(Array)
          expect(search.first).to be_a(Show)
        end
      end
    end
  end

  describe "#search_series_by_imdbId" do
    subject do
      TvdbApi.new("correct_key")
    end

    before do
      VCR.use_cassette('valid_token') do
        subject.load_token
      end
    end

    context "given a blank imdbId" do
      it "raises ArgumentError" do
        expect { subject.search_series_by_imdbId(' ') }.to raise_error(ArgumentError)
        expect { subject.search_series_by_imdbId(nil) }.to raise_error(ArgumentError)
      end
    end

    context "given an inexistent imdbId" do
      it "returns nil" do
        VCR.use_cassette('search_imdb_not_found') do
          expect(subject.search_series_by_imdbId('asjoasij')).to be_nil
        end
      end
    end

    context "given a correct imdbId" do
      it "returns search results" do
        VCR.use_cassette('search_imdb_found') do
          search = subject.search_series_by_imdbId("tt5834204")
          expect(search).to be_present
          expect(search).to be_a(Show)
        end
      end
    end
  end

  describe "#get_series_info" do
    subject do
      TvdbApi.new("correct_key")
    end

    before do
      VCR.use_cassette('valid_token') do
        subject.load_token
      end
    end

    context "given a blank id" do
      it "raises ArgumentError" do
        expect { subject.get_series_info(' ') }.to raise_error(ArgumentError)
        expect { subject.get_series_info(nil) }.to raise_error(ArgumentError)
      end
    end

    context "given an inexistent id" do
      it "returns nil" do
        VCR.use_cassette('info_id_not_found') do
          expect(subject.get_series_info('asjoasij')).to be_nil
        end
      end
    end

    context "given a correct id" do
      it "returns search results" do
        VCR.use_cassette('info_id_found') do
          search = subject.get_series_info("78804")
          expect(search).to be_present
          expect(search).to be_a(Show)
        end
      end

      it "is fully filled" do
        VCR.use_cassette('info_id_found') do
          search = subject.get_series_info("78804")
          expect(search.lastUpdated).to be_present
        end
      end
    end
  end
end
