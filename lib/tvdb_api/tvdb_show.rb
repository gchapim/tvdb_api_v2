class TvdbShow

  attr_accessor :name, :banner, :first_aired, :id, :network, :overview, :status, :runtime,
                :genre, :last_updated, :airs_day_of_week, :airs_time, :rating, :imdb_id, :zap2it_id,
                :added, :added_by, :site_rating, :site_rating_count

  def initialize(id, name, banner=nil, first_aired=nil, network=nil, overview=nil, status=nil,
                runtime=nil, genre=nil, last_updated=nil, airs_day_of_week=nil, airs_time=nil,
                rating=nil, imdb_id=nil, zap2it_id=nil, added=nil, added_by=nil, site_rating=nil,
                site_rating_count=nil)
    @id = id
    @name = name
    @banner = banner
    @first_aired = first_aired
    @network = network
    @overview = overview
    @status = status
    @runtime = runtime
    @genre = genre
    @last_updated = last_updated
    @airs_day_of_week = airs_day_of_week
    @airs_time = airs_time
    @rating = rating
    @imdb_id = imdb_id
    @zap2it_id = zap2it_id
    @added = added
    @added_by = added_by
    @site_rating = site_rating
    @site_rating_count = site_rating_count
  end

  def self.create(data)
    shows = data["data"]
    return if shows.blank?

    case shows
    when Hash
      show = populate(shows)
    when Array
      api_shows = []
      shows.each do |show|
        show = populate(show)
        api_shows << show
      end
      return api_shows.count > 1? api_shows : api_shows.first
    end
  end

  def self.populate(show)
    show = TvdbShow.new(show["id"].to_s, show["seriesName"].to_s, show["banner"], show["firstAired"],
                    show["network"], show["overview"], show["status"], show["runtime"], show["genre"],
                    show["lastUpdated"], show["airsDayOfWeel"], show["rating"], show["imdbId"],
                    show["zap2itId"], show["added"], show["addedBy"], show["siteRating"], show["siteRatingCount"])
  end
end
