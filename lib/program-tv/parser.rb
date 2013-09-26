module ProgramTV
  class Parser

    def initialize
      @agent = Mechanize.new
    end

    # Runs dynamic-sprites command.
    #
    def run
      ProgramTV.selected_channels.map do |url_name, epg_name|
        schedule(epg_name, "http://www.cyfrowypolsat.pl/program-tv/#{url_name}")
      end.compact
    end

    private

    def schedule(epg_name, url)
      page = Nokogiri::HTML(@agent.get(url).body)
      data = page.css(".main.col > table:last > tbody > tr").map do |e|
        {
          start:   running_time(e),
          channel: epg_name,
          title:   e.css('.name').text
        }
      end
      if data.empty?
        puts "Missing schedule for channel #{epg_name}"
        return
      end
      data[0..-2].each_with_index{ |element, i| element[:end] = data[i+1][:start] }
      data.pop
      data
    end

    # Methods to retrieve channel attributes
    def running_time(element)
      time = element.css('.time').text.match(/([0-9]+):([0-9]+)/)
      return nil unless time
      Time.new(Time.new.year,
               Time.new.month,
               Time.new.day,
               time[1],
               time[2])
    end
  end
end