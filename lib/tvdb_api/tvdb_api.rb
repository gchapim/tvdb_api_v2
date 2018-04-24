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
    manage_result(:show, name, :name)
  end

  def search_series_by_imdbId(imdb_id)
    manage_result(:show, imdb_id, :imdbId)
  end

  def get_series_info(id)
    manage_result(:show, id, :id)
  end

  def get_series_episodes(series_id)
    manage_result(:episode, series_id)
  end

  private

  def manage_result(type, parameter, parameter_type=nil)
    raise ArgumentError, '#{parameter_type} is blank' if parameter.blank?
    subaction = nil
    params = nil
    action = nil

    case type
    when :show
      case parameter_type
      when :id
        params = parameter
        action = :series
      else
        params = Hash.new
        params[parameter_type.to_sym] = parameter.html_safe
        action = :search
      end
    when :episode
      subaction = :episodes
      params = parameter
      action = :series
    end

    result = call_action(action, token, params, subaction)

    case type
    when :show
      shows = TvdbShow.create(result) unless result.blank?
    when :episode
      episodes = TvdbEpisode.create(result, parameter) unless result.blank?
    end
  end

  def call_action(action, token, params_hash=nil, subaction=nil)
    raise ArgumentError, 'wrong params' if action.blank? || !action.respond_to?(:to_sym) ||
                                           token.blank? || !token.respond_to?(:to_s) ||
                                           (subaction.present? && !subaction.respond_to?(:to_sym))

    params_hash.to_h if params_hash.present? && params_hash.respond_to?(:to_h)
    subaction.to_sym if subaction.present?
    TvdbApiWrapper.call_action(action.to_sym, token.to_s, params_hash, subaction)
  end
end
