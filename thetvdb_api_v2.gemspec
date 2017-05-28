Gem::Specification.new do |s|
  s.name        = 'thetvdb_api_v2'
  s.version     = '0.0.0'
  s.date        = '2017-05-28'
  s.summary     = "The Tvdb Api v2"
  s.description = "Ruby client for accessing TV shows information from the thetvdb.com JSON API v2"
  s.authors     = ["Gustavo Chapim"]
  s.email       = 'gustavo@chapim.com'
  s.files       = ["lib/thetvdb_api_v2rb"]
  s.homepage    =
  'http://rubygems.org/gems/thetvdb_api_v2'
  s.license       = 'MIT'


  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'httparty'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end


