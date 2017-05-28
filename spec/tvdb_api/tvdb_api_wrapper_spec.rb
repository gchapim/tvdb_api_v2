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
          expect(subject.get_token('valid_key')).to be_present
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

  describe '#refresh_token' do
    context 'given an empty token' do
      it 'raises ArgumentError' do
        expect {subject.refresh_token(' ')}.to raise_error(ArgumentError)
        expect {subject.refresh_token(nil)}.to raise_error(ArgumentError)
      end
    end

    context 'given an invalid token' do
      it 'raises UnauthorizedError' do
        stub_request(:post, 'https://api.thetvdb.com/refresh_token').to_return({ status: 401 })

        expect {subject.refresh_token('invalid_key')}.to raise_error(TheTvdbApi::UnauthorizedError)
      end
    end

    context 'given a valid token' do
      it 'generates a new token' do
        VCR.use_cassette('refresh_token') do
          expect(subject.refresh_token("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTYwOTA5NTQsImlkIjoiTmV0c2VyaWVzIiwib3JpZ19pYXQiOjE0OTYwMDQ1NTR9.GtNGgdpMAHNaTvDxLU9JjReAVkWNdP9dhn85BPAeu0COAgaiuAkoT5RL3b8HaCz92C8oD7_t3w-MRyzX5pJEo3JwrOTQNIAqHjzgfzhusjPEci2kWzmyFjXlwSKb2OFXuuArmeooJuM76-ip9Fgrlnh773aL4a_Uniuy6PCFAqSF8jw_-_XYNhQZ2LZnVMedErObeowIUQqILtPGLF1Uxs5tYDrTAzNg97EQM7wrKMgU3VEAsEhLmntieqGlO-Z3iIm4tYIWh_IeG4bCK0BszkT1l37wn3ZBn5beD8bbsUL9yorGPAPyXw0G4O2KcqxtpDBsCIxZYOt8EyDz9I4BYQ")).to be_present
        end
      end
    end
  end
end
