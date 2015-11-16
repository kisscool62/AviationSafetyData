load 'aviation_safety_wrapper.rb'
require 'CSV'

avw = AviationSafetyWrapper.new

year_links = avw.wrap_index
accidents = Array.new
year_links.each do |year_link|
    puts(year_link)
    accident_links = avw.wrap_accident_year_page(year_link)
    accident_links.each do |accident_link|
        puts(accident_link)
        accidents+=[avw.wrap_accident_page(accident_link)]
        #p accidents
        break
    end
    break
end

CSV.open("aviation_safety_data.csv", "wb") do |csv|
    variable_names = accidents[0].instance_variables
    csv.col_sep = ";"
    csv << variable_names
    accidents.each do |accident|
        values = variable_names.map do |variable_name|
            accident.instance_variable_get(variable_name)
        end
        csv << values
    end
end
