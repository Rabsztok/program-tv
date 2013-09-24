require 'builder'

module ProgramTV
  class Writer

    def initialize(data)
      @data = data
      @xml = Builder::XmlMarkup.new( :indent => 2 )
      @xml.instruct! :xml, :encoding => "UTF-8"
    end

    # Runs dynamic-sprites command.
    #
    def run
      @xml.tv do |tv|
        @data.flatten.each do |element|
          tv.programme do |p|
            p.title   element[:title]
            p.channel element[:channel]
            p.start   element[:start]
            p.end     element[:end]
          end
        end
      end
    end
  end
end