//
//  City.swift
//  WeatherUI
//
//  Created by un1kalny on 21/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import CoreData

struct City {
    static var listOfCities : [City] = []
    var title: String?
    var woeid: Int?
    var allDaysWeather: [DayWeather] = []
    var latt_long: String?
}

extension City {
    init?(json: [[String: Any]]) {
        for city in json {
            let title = city["title"] as? String
            let location_type = city["location_type"] as? String
            let woeid = city["woeid"] as? Int
            let latt_long = city["latt_long"] as? String
            
            self.title = title
            self.woeid = woeid
            self.latt_long = latt_long
            
            if(location_type == "City") {
                City.listOfCities.append(self)
            }
        }
    }
}
