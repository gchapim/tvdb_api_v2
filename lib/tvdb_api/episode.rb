class Episode
  attr_accessor :absolute_number, :aired_episode_number, :aired_season, :dvd_episode_number, :dvd_season, :episode_name,
                :first_aired, :id, :last_updated, :overview, :serie_id

  def initialize(id, serie_id, absolute_number=nil, aired_episode_number=nil, aired_season=nil, dvd_episode_number=nil, dvd_season=nil,
                 episode_name=nil, first_aired=nil, last_updated=nil, overview=nil)
    @id = id
    @serie_id = serie_id
    @absolute_number = absolute_number
    @aired_episode_number = aired_episode_number
    @aired_season = aired_season
    @dvd_episode_number = dvd_episode_number
    @dvd_season = dvd_season
    @episode_name = episode_name
    @first_aired = first_aired
    @last_updated = last_updated
    @overview = overview
  end

  def self.create(data, series_id)
    episodes = data["data"]
    return if episodes.blank || series_id.blank?

    case episodes
    when Hash
      episode = populate(episodes, series_id)
    when Array
      api_episodes = []
      episodes.each do |episode|
        episode = populate(episode, series_id)
        api_episodes << episode
      end
      return api_episodes.count > 1? api_episodes : api_episodes.first
    end
  end

  def self.populate(episode)
    episode = Episode.new(episode["id"], series_id, episode["absoluteNumber"], episode["airedEpisodeNumber"], episode["airedSeason"],
                          episode["dvdEpisodeNumber"], episode["dvdSeason"], episode["episodeName"], episode["firstAired"],
                          episode["lastUpdated"], episode["overview"])
  end
end
