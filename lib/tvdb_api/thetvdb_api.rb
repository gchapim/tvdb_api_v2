module TheTvdbApi

  TVDB_API_ADDRESS = 'https://api.thetvdb.com'

  ACTIONS = {login: "/login", refresh_token: "/refresh_token",
             search: "/search/series", series: "/series/"}

  class UnauthorizedError < StandardError; end
  class ConnectionError < StandardError; end
end
