require 'builder'
require_relative 'hash_helper'

module ProgramTV
  class Writer

    def initialize(data, destination)
      @data = data
      @destination = destination
    end

    def run
      @data.each do |schedule|
        today_schedule = []
        if File.exist?(xml_path(schedule))
          File.open(xml_path(schedule), "r+") do |file|
            today_schedule = Hash.from_xml(file.read)[:tv][:programme].map do |e|
              e[:attributes][:title] = e[:title]
              e[:attributes]
            end
          end
        end
        File.open(xml_path(schedule), "w+") do |file|
          file.write(build_xml(today_schedule + schedule))
        end
      end
    end

    private

    def xml_path(schedule)
      File.join(@destination, "epg_#{schedule.first[:channel]}.xml")
    end

    # Builds XML data from schedule Hash
    def build_xml(schedule)
      xml_builder = Builder::XmlMarkup.new( :indent => 2 )
      xml_builder.instruct! :xml, :encoding => "UTF-8"
      xml_builder.tv do |tv|
        schedule.each do |program|
          tv.programme :channel => program[:channel], :start => program[:start], :stop => program[:stop] do |p|
            p.title program[:title], :lang => 'pl'
            p.desc  
          end
        end
      end
    end
  end
end
