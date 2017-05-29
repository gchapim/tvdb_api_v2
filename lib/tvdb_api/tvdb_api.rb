class TvdbApi

  attr_reader :token

  def initialize(api_key)
    raise ArgumentError, 'api_key must be filled' if api_key.blank?
    @api_key = api_key
    @token = nil
  end

  def load_token
    @token = TvdbApiWrapper.get_token(@api_key)
  end

  def search_series_by_name(name)
    raise ArgumentError, 'name is blank' if name.blank?
    search_result = call_action(:search_by_name, token, {name: name.html_safe})
    shows = Show.create(search_result) unless search_result.blank?
  end

  private

  def call_action(action, token, params_hash=nil)
    raise ArgumentError, 'wrong params' if action.blank? || !action.respond_to?(:to_sym) ||
                                           token.blank? || !token.respond_to?(:to_s) ||
                                           (params_hash.present? && !params_hash.respond_to?(:to_h))

    params_hash.to_h if params_hash.present?
    TvdbApiWrapper.call_action(action.to_sym, token.to_s, params_hash)
  end
end
