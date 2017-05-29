module TheTvdbApi

  TVDB_API_ADDRESS = 'https://api.thetvdb.com'

  ACTIONS = {login: "/login", refresh_token: "/refresh_token",
             search: "/series/search"}

  class UnauthorizedError < StandardError; end
  class ConnectionError < StandardError; end
end
