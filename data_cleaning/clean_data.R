library(dplyr)
library(stringr)
library(ggplot2)
just_keep_country_of_location <- function(df){
    mutate(df, X.location =
               gsub(
                   gsub(
                       gsub(
                           gsub(
                               X.location,
                               pattern= "(.*\\([A-Z]{3}\\))(.*)",
                               replacement = "\\2"),
                           pattern= "^.*\\((.*)\\)",
                           replacement = "\\1"),
                       pattern = "Democratic Republic\\)",
                       replacement = "Congo"
                   ),
                   pattern = "[^a-zA-Z]*([a-zA-Z ]*)",
                   replacement = "\\1"
               )
    )
}

transform_time_to_day_period <- function(df){
    transform_toperiod <- function(date_char){
        res <- NA
        if(date_char >= "00:00" && date_char <= "07:00"){
            res <- "night"
        } else
            if(date_char > "07:00" && date_char <= "12:00"){
                res <- "morning"
            } else
                if(date_char > "12:00" && date_char <= "18:00"){
                    res <- "afternoon"
                } else
                    if(date_char > "18:00" && date_char <= "23:59"){
                        res <- "evening"
                    }
        res
    }

    df <- mutate(df, X.time = gsub(df$X.time, pattern = "ca | MSK| UTC", replacement = ""))
    df <- mutate(df, X.time_period = unlist(lapply(X.time, transform_toperiod)))
    df
}

create_old <- function(df){
    df <- mutate(df, X.old = X.year - as.numeric(gsub(X.first_flight, pattern="([0-9]{4}).*", replacement="\\1")) )
    df
}

create_year_accident <- function(df){
    df <- mutate(df, X.year = as.numeric(gsub(X.date, pattern = ".*([0-9]{4})", replacement = "\\1")))
    df
}

create_month_accident <- function(df){
    df <- mutate(df, X.month = gsub(X.date, pattern = "[a-zA-Z]+ [0-9]{1,2} ([a-zA-Z]+) [0-9]{4}", replacement = "\\1"))
    df
}

create_day_accident <- function(df){
    df <- mutate(df, X.day = gsub(X.date, pattern = "([a-zA-Z]+) [0-9]{1,2} [a-zA-Z]+ [0-9]{4}", replacement = "\\1"))
    df
}

create_nb_engines <- function(df){
    df <- mutate(df, X.nb_engines = as.numeric(gsub(X.engines, pattern = "([0-9]{1}) .*", replacement = "\\1")))
    df
}

only_country <- function(column){
    gsub(
        gsub(
            gsub(column, pattern=".*, ([A-Za-z ]*)$", replacement = "\\1"),
            pattern="\\?|-",
            replacement = NA
        ),
        pattern = ".* Congo \\(Democratic Republic\\)",
        replacement = "Congo")
}

get_only_country <- function(df){
    df <- mutate(
        df,
        X.departure_airport = only_country(X.departure_airport),
        X.destination_airport = only_country(X.destination_airport)
        )
}

create_crew <- function(df){
    df <- mutate(df, X.crew.fatalities = as.numeric(gsub(df$X.crew, pattern = "Fatalities: ([0-9]+) .*", replacement = "\\1")))
    df <- mutate(df, X.crew.occupants = as.numeric(gsub(df$X.crew, pattern = "Fatalities: [0-9]+ / Occupants: ([0-9]+)", replacement = "\\1")))
    df
}

create_passengers <- function(df){
    df <- mutate(df, X.passengers.fatalities = as.numeric(gsub(df$X.passengers, pattern = "Fatalities: ([0-9]+) .*", replacement = "\\1")))
    df <- mutate(df, X.passengers.occupants = as.numeric(gsub(df$X.passengers, pattern = "Fatalities: [0-9]+ / Occupants: ([0-9]+)", replacement = "\\1")))
    df
}

ratio <- function(a, b){
    ratios <- rep(NA, times = length(b))
    for(i in 1:length(b)){
        if(!(is.na(a[i]) || is.na(b[i]))){
            if(a[i] == 0 && b[i] == 0){
                ratios[i] <- 0
            }else {
                if(b[i] == 0){
                    ratios[i] <- NA
                }else{
                    ratios[i] <- a[i] / b[i]
                }
            }
        }else{
            ratios[i] <- NA
        }
    }
    ratios
}

create_crew_and_passengers_ratios <- function(df){

    df <- mutate(df, X.crew.ratio = ratio(X.crew.fatalities, X.crew.occupants))
    df <- mutate(df, X.passengers.ratio = ratio(X.passengers.fatalities, X.passengers.occupants))

    df
}

clean_airplane_damage <- function(df){
    df <- mutate(df, X.airplane_damage = gsub(str_trim(X.airplane_damage), pattern = "Unknown|^$", replacement=NA))
    df
}


extract_brand <- function(df){
    df <- mutate(df, X.brand = gsub(
        X.type,
        pattern="-",
        replacement = " "))

    df <- mutate(df, X.brand = gsub(
        X.brand,
        pattern=".*(McDonnell Douglas|Beechcraft|Boeing|Fokker|de Havilland Canada|Dassault Falcon|British Aerospace|Antonov|Hawker|Lockheed|Learjet|Eclipse|Swearingen|Cessna|Gulfstream|Xian|Embraer|Ilyushin|ShinMaywa|Airbus|CASA|Dornier|Canadair|IAI|ATR|Yakovlev|Bombardier|Britten Norman|Harbin Yunshuji|Viking Air|Saab|Let|Consolidated|Raytheon|Douglas|Sabreliner|Sukhoi|Curtiss|Convair|Dassault|Tupolev|PZL Mielec|Alenia/Aeritalia|Basler|National Aerospace Laboratories|HESA|Avro|Transall|AVIC|Excel|Shaanxi|Aero Modifications|Short|Aviation Traders|GAF|Lisunov|Volpar|Vickers|Fairchild|NAMC|Mitusbishi|Handley|Bristol|Commander|BAC|Aérospatiale|Hindustan Aeronautics|Sud Aviation|Grumman).*",
        replacement = "\\1"))
    df
}

clean_X.nature <- function(df){
    df <- mutate(df, X.nature = gsub(X.nature, pattern="Unknown|-", replacement = NA))
    df
}

clean_X.status <- function(df){
    df <- mutate(df, X.status = gsub(X.status, pattern="Unknown|-", replacement = NA))
    df
}

clean_X.phase <- function(df){
    df <- mutate(df, X.phase = gsub(X.phase, pattern="([A-Za-z]+) \\([A-Z]{3}\\)", replacement="\\1"))
    df <- mutate(df, X.phase = gsub(str_trim(X.phase), pattern="Unknown|^$", replacement=NA))
    df
}

df <- read.csv('aviation_safety_data.csv', , encoding="UTF-8-BOM")

df <- just_keep_country_of_location(df)

df <- transform_time_to_day_period(df)

df <- create_year_accident(df)

df <- create_month_accident(df)

df <- create_day_accident(df)

df <- create_old(df)

df <- get_only_country(df)

df <- mutate(df, X.operator = gsub(str_trim(X.operator), pattern = "^$|Unknown", replacement = NA))

df <- create_nb_engines(df)

df <- create_crew(df)

df <- create_passengers(df)

df <- create_crew_and_passengers_ratios(df)

df <- clean_X.nature(df)

df <- clean_X.phase(df)

df <- clean_X.status(df)

df <- clean_airplane_damage(df)

df <- mutate(df, X.registration_clean = gsub(X.registration, pattern = "registration unknown", replacement = NA))

df <- extract_brand(df)

View(df)

df$X.registration_clean[which(duplicated(as.character(df$X.registration_clean)))]
# View(df[df$X.registration=="C-GKBC",])
# View(df[df$X.registration=="N120SC",])
# View(df[df$X.registration=="PK-YRU",])
# View(df[df$X.registration=="N3125N",])

View(df[,c("X.operator", "X.registration", "X.airplane_damage", "X.location", "X.phase", "X.nature", "X.departure_airport", "X.destination_airport", "X.time_period", "X.year", "X.month", "X.day", "X.old", "X.nb_engines", "X.crew.fatalities", "X.crew.occupants", "X.passengers.fatalities", "X.passengers.occupants", "X.crew.ratio", "X.passengers.ratio", "X.registration_clean", "X.brand")])

df <- mutate(df, X.reg_id = X.registration_clean)

df_cleaned <- na.omit(df[,c("X.reg_id", "X.operator", "X.airplane_damage", "X.location", "X.phase", "X.nature", "X.departure_airport", "X.destination_airport", "X.time_period", "X.year", "X.month", "X.day", "X.old", "X.nb_engines", "X.crew.fatalities", "X.crew.occupants", "X.passengers.fatalities", "X.passengers.occupants", "X.crew.ratio", "X.passengers.ratio", "X.brand")])

View(df_cleaned)

write.csv(x=df_cleaned, file='aviation_safety_data_clean.csv', row.names=FALSE, fileEncoding="UTF-8")
