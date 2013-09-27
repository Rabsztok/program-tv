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
      @additional_day = false
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
      data[0..-2].each_with_index do |element, i|
        element[:stop] = data[i+1][:start]
        if element[:stop] < element[:start]
          @additional_day = true
          element[:stop] += 86400
        elsif @additional_day
          element[:start] += 86400
          element[:stop] += 86400
        end
        element[:start] = element[:start].strftime("%Y%m%d%H%M%S %z")
        element[:stop] = element[:stop].strftime("%Y%m%d%H%M%S %z")
      end
      data.pop
      data
    end

    # Methods to retrieve channel attributes
    def running_time(element)
      time = element.css('.time').text.match(/([0-9]+):([0-9]+)/)
      return nil unless time
      Time.new(Time.new.year,
               Time.new.month,
               Time.new.day + 1,
               time[1],
               time[2])
    end
  end
end
