require 'spec_helper'
require 'webmock/rspec'
require 'webmock'
require 'vcr'
require 'support/vcr_setup'

RSpec.describe TvdbApiWrapper do
  subject do
    TvdbApiWrapper.new
  end

  describe '#get_token' do
    context 'given an invalid key' do
      it 'raises ArgumentError' do
        expect {subject.get_token(' ')}.to raise_error(ArgumentError)
        expect {subject.get_token(nil)}.to raise_error(ArgumentError)
      end
    end

    context 'given a wrong key' do
      before { VCR.turn_off! }
      after { VCR.turn_on! }

      it 'raises UnauthorizedError' do
        stub_request(:post, 'https://api.thetvdb.com/login').to_return({ status: 401 })

        expect {subject.get_token('invalid_key')}.to raise_error(TheTvdbApi::UnauthorizedError)
      end
    end

    context 'given a valid key' do
      it 'returns valid token' do
        VCR.use_cassette('valid_token') do
          expect(subject.get_token('valid_token')).to be_present
        end
      end
    end

    context 'api is unavailable' do
      before { VCR.turn_off! }
      after { VCR.turn_on! }

      it 'raises ConnectionError' do
        stub_request(:post, 'https://api.thetvdb.com/login').to_return({ status: 500 })
        expect {subject.get_token('valid_key')}.to raise_error(TheTvdbApi::ConnectionError)
      end
    end
  end
end
