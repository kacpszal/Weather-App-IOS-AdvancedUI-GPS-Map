//
//  AddCityViewController.swift
//  WeatherUI
//
//  Created by un1kalny on 21/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentUserLocationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var listOfNearestCities: [City] = []
    var parentOfCity: String = ""
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.listOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        cell.textLabel?.text = City.listOfCities[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var added = false
        var currentCity = City.listOfCities[indexPath.row]
        
        if(Cities.instance.objects.contains{$0.title == currentCity.title}) {
            performSegue(withIdentifier: "backToMainView", sender: self)
            return
        }
        
        let urlString = URL(string: "https://www.metaweather.com/api/location/\(currentCity.woeid!)/")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        DayWeather(json: json as! [String: Any])
                        currentCity.allDaysWeather.append(contentsOf: DayWeather.allDaysWeather)
                        DayWeather.allDaysWeather.removeAll()
                        added = true
                    }
                }
            }
            task.resume()
            while(!added) {
                //wait
            }
        }
        
        for (index, element) in currentCity.allDaysWeather.enumerated() {
            if let unwrappedWeatherStateAbbr = element.weatherStateAbbr {
                let image = try? UIImage(data: Data(contentsOf: URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(unwrappedWeatherStateAbbr).png")!))
                currentCity.allDaysWeather[index].uiImage = image!
            }
        }
        
        currentCity.allDaysWeather.append(contentsOf: DayWeather.allDaysWeather)
        Cities.instance.objects.append(currentCity)
        Cities.currentCity = currentCity
        performSegue(withIdentifier: "backToMainView", sender: self)
        City.listOfCities.removeAll()
    }
    
    @IBOutlet weak var citiesTable: UITableView!
    
    @IBOutlet weak var cityNameInput: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        let urlString = URL(string: "https://www.metaweather.com/api/location/search/?query=\(cityNameInput.text!)")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        if(json != nil) {
                            City.listOfCities.removeAll()
                            City(json: json as! [[String : Any]])
                        }
                        DispatchQueue.main.async {
                            self.citiesTable.reloadData()
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    @IBAction func findNearestCitiesButton(_ sender: Any) {
        City.listOfCities = listOfNearestCities
        DispatchQueue.main.async {
            self.citiesTable.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        currentLocation = lastLocation.coordinate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        var getResponse = false
        
        let urlString = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(currentLocation.latitude),\(currentLocation.longitude)")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        if(json != nil) {
                            City.listOfCities.removeAll()
                            City(json: json as! [[String : Any]])
                            self.listOfNearestCities = City.listOfCities
                            City.listOfCities.removeAll()
                            getResponse = true
                        }
                    }
                }
            }
            task.resume()
            while(!getResponse) {
                //wait
            }
        }
        
        currentUserLocationLabel.text = "Your location: \(listOfNearestCities[0].title!)"
        currentUserLocationLabel.textAlignment = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
