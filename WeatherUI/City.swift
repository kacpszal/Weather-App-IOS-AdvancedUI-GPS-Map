//
//  City.swift
//  WeatherUI
//
//  Created by un1kalny on 21/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

//import UIKit
import CoreData

struct City {
    static var listOfCities : [City] = []
    var title: String?
    var woeid: Int?
    var allDaysWeather: [DayWeather] = []
}

extension City {
    init?(json: [[String: Any]]) {
        for city in json {
            let title = city["title"] as? String
            let location_type = city["location_type"] as? String
            let woeid = city["woeid"] as? Int
            
            self.title = title
            self.woeid = woeid
            
            if(location_type == "City") {
                City.listOfCities.append(self)
            }
        }
    }
}
