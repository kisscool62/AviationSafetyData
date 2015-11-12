class Accident
    def initialize(
        status, date,
        time, type,
        operator,registration,
        first_flight, engines,
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
            puts map
            return Accident.new(status, date,
                                time, type,
                                operator,registration,
                                first_flight, engines,
                                crew, passengers,
                                airplane_damage, airplane_fate,
                                location, phase, nature,
                                departure_airport, destination_airport,
                                flight_number)
    end
end