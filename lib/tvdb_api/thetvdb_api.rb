module TheTvdbApi

  TVDB_API_ADDRESS = 'https://api.thetvdb.com'

  class UnauthorizedError < StandardError; end
  class ConnectionError < StandardError; end
end
