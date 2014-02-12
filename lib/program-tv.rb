module ProgramTV

  #----------------------------------------------------------------------------

  VERSION     = "0.1.0"
  SUMMARY     = "TV Channel parser"
  DESCRIPTION = "Downloads TV channel list in XML format"

  require 'yaml'
  require 'mechanize'
  require 'nokogiri'

  require_relative 'program-tv/parser'  # Parsing from website
  require_relative 'program-tv/writer'  # Writing from ruby hash to XML

  # Initilizes Runner which controls all the magic stuff.
  #
  def self.run!(options = {})
    @@options = options
    data = Parser.new.run
    Writer.new(data, @@options[:destination]).run
  end

  private

  def self.gem_root
    File.expand_path '../..', __FILE__
  end

  def self.selected_channels
    @channels ||= YAML::load(File.open(@@options[:channel_list] || File.join(gem_root, 'channels.yml')))
  end
end
