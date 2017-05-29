class Show

  attr_accessor :name, :banner, :firstAired, :id, :network, :overview, :status, :runtime,
                :genre, :lastUpdated, :airsDayOfWeek, :airsTime, :rating, :imdbId, :zap2itId,
                :added, :addedBy, :siteRating, :siteRatingCount

  def initialize(id, name, banner=nil, firstAired=nil, network=nil, overview=nil, status=nil,
                runtime=nil, genre=nil, lastUpdated=nil, airsDayOfWeek=nil, airsTime=nil,
                rating=nil, imdbId=nil, zap2itId=nil, added=nil, addedBy=nil, siteRating=nil,
                siteRatingCount=nil)
    @id = id
    @name = name
    @banner = banner
    @firstAired = firstAired
    @network = network
    @overview = overview
    @status = status
    @runtime = runtime
    @genre = genre
    @lastUpdated = lastUpdated
    @airsDayOfWeek = airsDayOfWeek
    @airsTime = airsTime
    @rating = rating
    @imdbId = imdbId
    @zap2itId = zap2itId
    @added = added
    @addedBy = addedBy
    @siteRating = siteRating
    @siteRatingCount = siteRatingCount
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
    show = Show.new(show["id"].to_s, show["seriesName"].to_s, show["banner"], show["firstAired"],
                    show["network"], show["overview"], show["status"], show["runtime"], show["genre"],
                    show["lastUpdated"], show["airsDayOfWeel"], show["rating"], show["imdbId"],
                    show["zap2itId"], show["added"], show["addedBy"], show["siteRating"], show["siteRatingCount"])
  end
end
