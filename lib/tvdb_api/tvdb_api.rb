class TvdbApi

  attr_reader :token

  def initialize(api_key)
    raise ArgumentError, 'api_key must be filled' if api_key.blank?
    @api_key = api_key
    @token = nil
    @tvdb_api_wrapper = TvdbApiWrapper.new
  end

  def load_token
    @token = @tvdb_api_wrapper.get_token(@api_key)
  end
end
