class Show

  attr_accessor :name, :banner, :firstAired, :id, :network, :overview, :status

  def initialize(id, name, banner=nil, firstAired=nil, network=nil, overview=nil, status=nil)
    @id = id
    @name = name
    @banner = banner
    @firstAired = firstAired
    @network = network
    @overview = overview
    @status = status
  end

  def self.create(data)
    shows = data["data"]
    return if shows.blank?

    api_shows = []
    shows.each do |show|
      show = populate(show)
      api_shows << show
    end
    return api_shows.count > 1? api_shows : api_shows.first
  end

  def self.populate(show)
    show = Show.new(show["id"], show["seriesName"], show["banner"], show["firstAired"],
                    show["network"], show["overview"], show["status"])
  end
end
