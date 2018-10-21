//
//  Cities.swift
//  WeatherUI
//
//  Created by un1kalny on 21/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import Foundation

class Cities {
    static let instance: Cities = Cities()
    
    var objects: [City]
    
    private init() {
        objects = [City]()
    }
}
