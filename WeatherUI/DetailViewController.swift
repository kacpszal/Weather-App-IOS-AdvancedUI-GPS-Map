//
//  DetailViewController.swift
//  WeatherUI
//
//  Created by un1kalny on 20/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var navigationLabel: UINavigationItem!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var weatherStateLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var airPressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    var numberOfDay = 0
    var previousButtonShouldBeEnabled = false
    var nextButtonShouldBeEnabled = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previousButton.isEnabled = previousButtonShouldBeEnabled
        nextButton.isEnabled = nextButtonShouldBeEnabled
        
        var currentCity = Cities.currentCity!
        
        if(numberOfDay < 0) {
            numberOfDay = 0
        }
        
        if(numberOfDay > currentCity.allDaysWeather.count - 1) {
            numberOfDay = currentCity.allDaysWeather.count - 1
        }
        
        if(currentCity.allDaysWeather.count != 0) {
            imageView.image = currentCity.allDaysWeather[self.numberOfDay].uiImage
            
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = false
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .decimal
            
            let noDataString = "no data"
            self.dateLabel.text = currentCity.allDaysWeather[self.numberOfDay].applicableDate
            self.weatherStateLabel.text = currentCity.allDaysWeather[self.numberOfDay].weatherStateName
            if let unwrappedMinTemp = currentCity.allDaysWeather[self.numberOfDay].minTemp {
                self.minTempLabel.text = "\(Int(unwrappedMinTemp)) °C"
            } else {
                self.minTempLabel.text = noDataString
            }
            if let unwrappedMaxTemp = currentCity.allDaysWeather[self.numberOfDay].maxTemp {
                self.maxTempLabel.text = "\(Int(unwrappedMaxTemp)) °C"
            } else {
                self.maxTempLabel.text = noDataString
            }
            if let unwrappedWindSpeed = currentCity.allDaysWeather[self.numberOfDay].windSpeed {
                self.windSpeedLabel.text = "\(formatter.string(from: unwrappedWindSpeed as NSNumber)!) mph"
            } else {
                self.windSpeedLabel.text = noDataString
            }
            if let unwrappedWindDirection = currentCity.allDaysWeather[self.numberOfDay].windDirection {
                self.windDirectionLabel.text = "\(formatter.string(from: unwrappedWindDirection as NSNumber)!) °"
            } else {
                self.windDirectionLabel.text = noDataString
            }
            if let unwrappedAirPressure = currentCity.allDaysWeather[self.numberOfDay].airPressure {
                self.airPressureLabel.text = "\(formatter.string(from: unwrappedAirPressure as NSNumber)!) hPa"
            } else {
                self.windSpeedLabel.text = noDataString
            }
            if let unwrappedHumidity = currentCity.allDaysWeather[self.numberOfDay].humidity {
                self.humidityLabel.text = "\(unwrappedHumidity) %"
            } else {
                self.humidityLabel.text = noDataString
            }
        }
    }
    
    @IBAction func clickPreviousButton(_ sender: Any) {
        self.numberOfDay -= 1
        if(self.numberOfDay == 0) {
            self.previousButtonShouldBeEnabled = false
        }
        self.nextButtonShouldBeEnabled = true
        DispatchQueue.main.async {
            self.viewWillAppear(true)
        }
    }
    
    @IBAction func clickNextButton(_ sender: Any) {
        self.numberOfDay += 1
        if(self.numberOfDay == Cities.currentCity!.allDaysWeather.count - 1) {
            self.nextButtonShouldBeEnabled = false
        }
        self.previousButtonShouldBeEnabled = true
        DispatchQueue.main.async {
            self.viewWillAppear(true)
        }
    }
    
    func configureView() {
        if let label = navigationLabel {
            label.title = Cities.currentCity!.title!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

