class Accident
    def initialize(
        status, date,
        time, type,
        operator,registration,
        first_flight, total_airframe_hrs, engines,
        crew, passengers,
        airplane_damage, airplane_fate,
        location, phase, nature,
        departure_airport, destination_airport,
        flight_number)

            @status = status 
            @date = date
            @time = time
            @type = type
            @operator = operator
            @registration = registration
            @first_flight = first_flight
            @total_airframe_hrs = total_airframe_hrs
            @engines = engines
            @crew = crew
            @passengers = passengers
            @airplane_damage = airplane_damage
            @airplane_fate = airplane_fate
            @location = location
            @phase = phase
            @nature = nature
            @departure_airport = departure_airport
            @destination_airport = destination_airport
            @flight_number = flight_number
    end

    def self.build(map)
            return Accident.new(map["status"], map["date"],
                                map["time"], map["type"],
                                map["operator"]!=nil ? map["operator"] : map["operating_for"], map["registration"],
                                map["first_flight"], map["total_airframe_hrs"], map["engines"],
                                map["crew"], map["passengers"],
                                map["airplane_damage"], map["airplane_fate"],
                                map["location"], map["phase"], map["nature"],
                                map["departure_airport"], map["destination_airport"],
                                map["flightnumber"])
    end

    def to_map_from_variable_list(wanted_variable_names)
        return wanted_variable_names.map do |variable_name|
                    self.instance_variable_get(variable_name)
         end

    end

    def self.to_map
            return self.to_map_from_variable_list(self.instance_variables)
    end
end