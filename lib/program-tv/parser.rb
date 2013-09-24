module ProgramTV
  class Parser

    def initialize
      @agent = Mechanize.new
      @channel_list_url = "http://www.cyfrowypolsat.pl/program-tv/lista-kanalow/"
    end

    # Runs dynamic-sprites command.
    #
    def run
      channel_urls.map do |url|
        schedule(url)
      end
    end

    private

    def schedule(url)
      page = Nokogiri::HTML(@agent.get(url).body)
      data = page.css(".main.col > table:last > tbody > tr").map do |e|
        {
          start:   running_time(e),
          channel: url.match(/([^\/]+)\/;/)[1].to_s,
          title:   e.css('.name').text
        }
      end
      data[0..-2].each_with_index{ |element, i| element[:end] = data[i+1][:start] }
      data.last[:end] = data.first[:start]
      data
    end

    # Fetches page with channel list and returns Array of urls to subpages with channel schedule
    def channel_urls
      page = Nokogiri::HTML(@agent.get(@channel_list_url).body)
      page.css('.rowChannel a').select{ |c| ProgramTV.selected_channels.include?(c.text.to_s.strip) }.map{ |c| c.attr('href') }
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