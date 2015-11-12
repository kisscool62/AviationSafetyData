load 'aviation_safety_wrapper.rb'

avw = AviationSafetyWrapper.new

year_links = avw.wrap_index
accidents = Array.new
year_links.each do |year_link|
    puts(year_link)
    accident_links = avw.wrap_accident_year_page(year_link)
    accident_links.each do |accident_link|
        puts(accident_link)
        accidents+=[avw.wrap_accident_page(accident_link)]
        p accidents
        exit
    end
    exit
end

accidents.each do |accident|
    p accident
end
