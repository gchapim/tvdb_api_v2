require 'httparty'
require 'json'

include TheTvdbApi

class TvdbApiWrapper
  def get_token(api_key)
    raise ArgumentError, 'api_key must be filled' if api_key.blank?

    response = token_from_login(api_key)
    token_from_response(response)
  end

  def refresh_token(token)
    raise ArgumentError, 'token must be filled' if token.blank?
    response = get_response("/refresh_token", token)
    token_from_response(response)
  end

  private

  def token_from_login(api_key)
    response = HTTParty.post("#{TVDB_API_ADDRESS}/login",
                             { body: { "apikey": "#{api_key}" }.to_json,
                               headers: { "Content-Type": "application/json",
                                         "Accept": "application/json"}})
  end

  def get_response(action, token, params=nil)
    response = HTTParty.get("#{TVDB_API_ADDRESS}#{action}",
                             { headers: { "Content-Type": "application/json",
                                         "Accept": "application/json",
                                         "Authorization": "Bearer #{token}"}})
  end

  def token_from_response(response)
    raise UnauthorizedError, 'Unauthorized' if response.code == 401
    raise ConnectionError, "Couldn't connect to api" if ['200', '201']
      .exclude?(response.code.to_s) || response.body.blank?

    json_hash = JSON.parse(response.body)
    json_hash["token"]
  end

end
