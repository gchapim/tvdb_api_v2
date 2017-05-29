require 'httparty'
require 'json'

include TheTvdbApi

class TvdbApiWrapper
  def self.get_token(api_key)
    raise ArgumentError, 'api_key must be filled' if api_key.blank?

    response = token_from_login(api_key)
    token_from_response(response)
  end

  def self.call_action(action, token, params=nil)
    raise ArgumentError, 'token must be filled' if token.blank?
    response = get_response(action, token, params)
    json_from_response(response)
  end

  private

  def self.token_from_login(api_key)
    response = HTTParty.post("#{TVDB_API_ADDRESS}#{ACTIONS[:login]}",
                             { body: { "apikey": "#{api_key.to_s}" }.to_json,
                               headers: { "Content-Type": "application/json",
                                         "Accept": "application/json"}})
  end

  def self.get_response(action, token, params=nil)
    params = params.to_h if params.present?
    response = HTTParty.get("#{TVDB_API_ADDRESS}#{ACTIONS[action.to_sym]}",
                             { headers: { "Content-Type": "application/json",
                                         "Accept": "application/json",
                                         "Authorization": "Bearer #{token.to_s}"},
                               query: params})
  end

  def self.token_from_response(response)
    json_hash = json_from_response(response)
    json_hash["token"]
  end

  def self.json_from_response(response)
    raise UnauthorizedError, 'Unauthorized' if response.code == 401
    raise ConnectionError, "Couldn't connect to api" if ['200', '201', '404']
      .exclude?(response.code.to_s) || response.body.blank?
    return nil if response.code == 404

    json_hash = JSON.parse(response.body)
  end
end
