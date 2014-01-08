Gem::Specification.new do |s|
  s.name        = 'program-tv'
  s.version     = '0.0.8'
  s.executables << 'program-tv'
  s.date        = '2013-09-24'
  s.summary     = "TV Channel parser"
  s.description = "Downloads TV channel schedule in XML format"
  s.authors     = ["Maciej Walusiak"]
  s.email       = 'rabsztok@gmail.com'
  s.files       = ["bin/program-tv", "lib/program-tv.rb", "lib/program-tv/parser.rb", "lib/program-tv/writer.rb", "lib/program-tv/hash_helper.rb", "channels.yml"]
  s.homepage    = 'https://github.com/Rabsztok/program-tv'
  s.license     = 'GPL'
  s.add_dependency "builder"
  s.add_dependency "mechanize"
  s.add_dependency "nokogiri"
end
