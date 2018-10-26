//
//  DayWeather.swift
//  WeatherUI
//
//  Created by un1kalny on 25/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit

struct DayWeather {
    static var allDaysWeather : [DayWeather] = []
    var applicableDate : String?
    var weatherStateName : String?
    var weatherStateAbbr : String?
    var minTemp : Double?
    var theTemp : Double?
    var maxTemp : Double?
    var windSpeed : Double?
    var windDirection : Double?
    var airPressure : Double?
    var humidity : Int?
    var uiImage : UIImage? = nil
}

extension DayWeather {
    init?(json: [String: Any]) {
        guard let consolidatedWeather = json["consolidated_weather"] as? [[String: Any]]
            else {
                DayWeather.allDaysWeather.append(self)
                return nil
        }
        for day in consolidatedWeather {
            let applicableDate = day["applicable_date"] as? String
            let weatherStateName = day["weather_state_name"] as? String
            let weatherStateAbbr = day["weather_state_abbr"] as? String
            let minTemp = day["min_temp"] as? Double
            let theTemp = day["the_temp"] as? Double
            let maxTemp = day["max_temp"] as? Double
            let windSpeed = day["wind_speed"] as? Double
            let windDirection = day["wind_direction"] as? Double
            let airPressure = day["air_pressure"] as? Double
            let humidity = day["humidity"] as? Int
            
            self.applicableDate = applicableDate
            self.weatherStateName = weatherStateName
            self.weatherStateAbbr = weatherStateAbbr
            self.minTemp = minTemp
            self.theTemp = theTemp
            self.maxTemp = maxTemp
            self.windSpeed = windSpeed
            self.windDirection = windDirection
            self.airPressure = airPressure
            self.humidity = humidity
            
            DayWeather.allDaysWeather.append(self)
        }
        
    }
}
