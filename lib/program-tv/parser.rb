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
      data = build_hash epg_name, page.css(".main.col > table:first > tbody > tr")
      data += build_hash epg_name, page.css(".main.col > table:last > tbody > tr"), 1
      puts "Missing schedule for channel #{epg_name}" and return if data.empty?
    end

    # convert nokogiri html data to handy hash structure
    def build_hash(epg_name, data, offset = 0)
      additional_day = false
      data = data.map do |e|
        {
          start:   running_time(e, offset),
          channel: epg_name,
          title:   e.css('.name').text
        }
      end
      data[0..-2].each_with_index do |element, i|
        element[:stop] = data[i+1][:start]
        if element[:stop] < element[:start]
          additional_day = true
          element[:stop] += 86400
        elsif additional_day
          element[:start] += 86400
          element[:stop] += 86400
        end
        element[:start] = element[:start].strftime("%Y%m%d%H%M%S %z")
        element[:stop] = element[:stop].strftime("%Y%m%d%H%M%S %z")
      end
      data.pop
      return data
    end

    # Methods to retrieve channel attributes
    def running_time(element, offset = 0)
      time = element.css('.time').text.match(/([0-9]+):([0-9]+)/)
      return nil unless time
      Time.new(Time.new.year,
               Time.new.month,
               Time.new.day + offset,
               time[1],
               time[2])
    end
  end
end
