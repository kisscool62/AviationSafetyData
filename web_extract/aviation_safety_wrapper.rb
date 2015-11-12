require 'rubygems'
require 'mechanize'
load 'accident.rb'

class String
    def numeric?
        return true if self =~ /\A\d+\Z/
        true if Integer(self) rescue false
    end

    def match?(regexp)
        return true unless self.match(regexp).nil?
    end
end

class AviationSafetyWrapper
    @@WEB_SITE_ROOT = 'http://aviation-safety.net'

    def wrap_accident_table(tr_list)
        map = Hash.new
        tr_list.each do |tr|
            tds = tr.search('td')
            map[tds[0].text.downcase.tr(':', '').tr(' ', '_').strip] = tds[1].text.strip
        end
        return map
    end

    def wrap_accident_page(link)
        a = Mechanize.new
        a.get(@@WEB_SITE_ROOT + link.href) do |page|
            map = wrap_accident_table(page.search('//table[not(@class = "hp")]').search('tr'))
            return Accident.build(map)
        end

    end

    def wrap_accident_year_page(link)
        a = Mechanize.new
        year = link.text.strip
        puts(@@WEB_SITE_ROOT + '/database/' + link.href)
        a.get(@@WEB_SITE_ROOT + '/database/' + link.href) do |page|
            return page.links.select { |link| correct_accident_links(link, year) }
        end
    end

    def wrap_index
        a = Mechanize.new
        a.get(@@WEB_SITE_ROOT + '/database/' ) do |page|
            return page.links.select { |link| correct_year_links(link) }
        end
    end


    private

    def correct_accident_links(link, year)
        text = link.text.strip
        return true if text.length > 0 and text.match?('[0-9]{2}-[A-Z]{3}-' + year.upcase)
    end

    def correct_year_links(link)
        text = link.text.strip
        return true if text.length > 0 and text.numeric? and Integer(text) >= 2004 rescue false
    end

end