require 'spec_helper'
require 'webmock/rspec'
require 'webmock'
require 'vcr'
require 'support/vcr_setup'

RSpec.describe TvdbApiWrapper do
  describe '#get_token' do
    context 'given an invalid key' do
      it 'raises ArgumentError' do
        expect {TvdbApiWrapper.get_token(' ')}.to raise_error(ArgumentError)
        expect {TvdbApiWrapper.get_token(nil)}.to raise_error(ArgumentError)
      end
    end

    context 'given a wrong key' do
      before { VCR.turn_off! }
      after { VCR.turn_on! }

      it 'raises UnauthorizedError' do
        stub_request(:post, 'https://api.thetvdb.com/login').to_return({ status: 401 })

        expect {TvdbApiWrapper.get_token('invalid_key')}
          .to raise_error(TheTvdbApi::UnauthorizedError)
      end
    end

    context 'given a valid key' do
      it 'returns valid token' do
        VCR.use_cassette('valid_token') do
          expect(TvdbApiWrapper.get_token('valid_key')).to be_present
        end
      end
    end

    context 'api is unavailable' do
      before { VCR.turn_off! }
      after { VCR.turn_on! }

      it 'raises ConnectionError' do
        stub_request(:post, 'https://api.thetvdb.com/login').to_return({ status: 500 })

        expect {TvdbApiWrapper.get_token('valid_key')}
          .to raise_error(TheTvdbApi::ConnectionError)
      end
    end
  end

  describe '#call_action' do
    context 'given an empty token' do
      it 'raises ArgumentError' do
        expect {TvdbApiWrapper.call_action(:refresh_token, ' ')}
          .to raise_error(ArgumentError)
        expect {TvdbApiWrapper.call_action(:refresh_token, nil)}
          .to raise_error(ArgumentError)
      end
    end

    context 'given an invalid token' do
      before { VCR.turn_off! }
      after { VCR.turn_on! }

      it 'raises UnauthorizedError' do
        stub_request(:get, 'https://api.thetvdb.com/refresh_token')
          .to_return({ status: 401 })

        expect {TvdbApiWrapper.call_action(:refresh_token, 'invalid_key')}
          .to raise_error(TheTvdbApi::UnauthorizedError)
      end
    end

    context 'given an action with params' do
      it 'returns correctly' do
        token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTYwOTA5NTQsImlkIjoiTmV0c2VyaWVzIiwib3JpZ19p" +
              "YXQiOjE0OTYwMDQ1NTR9.GtNGgdpMAHNaTvDxLU9JjReAVkWNdP9dhn85BPAeu0COAgaiuAkoT5RL3b8HaCz92C8oD7_t" +
              "3w-MRyzX5pJEo3JwrOTQNIAqHjzgfzhusjPEci2kWzmyFjXlwSKb2OFXuuArmeooJuM76-ip9Fgrlnh773aL4a_Uniuy6" +
              "PCFAqSF8jw_-_XYNhQZ2LZnVMedErObeowIUQqILtPGLF1Uxs5tYDrTAzNg97EQM7wrKMgU3VEAsEhLmntieqGlO-Z3iIm4tYIW" +
              "h_IeG4bCK0BszkT1l37wn3ZBn5beD8bbsUL9yorGPAPyXw0G4O2KcqxtpDBsCIxZYOt8EyDz9I4BYQ"

        VCR.use_cassette('search_found') do
          json = TvdbApiWrapper.call_action(:search, token, {name: 'Doctor Who'})
          expect(json).to be_present
          expect(json).to be_a(Hash)
        end
      end
    end

    context 'given a valid token and refresh_token action' do
      it 'generates a new token' do
        token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTYwOTA5NTQsImlkIjoiTmV0c2VyaWVzIiwib3JpZ19p" +
              "YXQiOjE0OTYwMDQ1NTR9.GtNGgdpMAHNaTvDxLU9JjReAVkWNdP9dhn85BPAeu0COAgaiuAkoT5RL3b8HaCz92C8oD7_t" +
              "3w-MRyzX5pJEo3JwrOTQNIAqHjzgfzhusjPEci2kWzmyFjXlwSKb2OFXuuArmeooJuM76-ip9Fgrlnh773aL4a_Uniuy6" +
              "PCFAqSF8jw_-_XYNhQZ2LZnVMedErObeowIUQqILtPGLF1Uxs5tYDrTAzNg97EQM7wrKMgU3VEAsEhLmntieqGlO-Z3iIm4tYIW" +
              "h_IeG4bCK0BszkT1l37wn3ZBn5beD8bbsUL9yorGPAPyXw0G4O2KcqxtpDBsCIxZYOt8EyDz9I4BYQ"

        VCR.use_cassette('refresh_token') do
          new_token = TvdbApiWrapper.call_action(:refresh_token, token)
          expect(new_token).to be_present
          expect(new_token).to_not be_eql(token)
        end
      end
    end

    context 'given a id string as param' do
      it 'returns correctly' do
        token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTYwOTA5NTQsImlkIjoiTmV0c2VyaWVzIiwib3JpZ19p" +
              "YXQiOjE0OTYwMDQ1NTR9.GtNGgdpMAHNaTvDxLU9JjReAVkWNdP9dhn85BPAeu0COAgaiuAkoT5RL3b8HaCz92C8oD7_t" +
              "3w-MRyzX5pJEo3JwrOTQNIAqHjzgfzhusjPEci2kWzmyFjXlwSKb2OFXuuArmeooJuM76-ip9Fgrlnh773aL4a_Uniuy6" +
              "PCFAqSF8jw_-_XYNhQZ2LZnVMedErObeowIUQqILtPGLF1Uxs5tYDrTAzNg97EQM7wrKMgU3VEAsEhLmntieqGlO-Z3iIm4tYIW" +
              "h_IeG4bCK0BszkT1l37wn3ZBn5beD8bbsUL9yorGPAPyXw0G4O2KcqxtpDBsCIxZYOt8EyDz9I4BYQ"

        VCR.use_cassette('series_info') do
          json = TvdbApiWrapper.call_action(:series, token, '78804')
          expect(json).to be_present
          expect(json).to be_a(Hash)
        end
      end
    end
  end
end
