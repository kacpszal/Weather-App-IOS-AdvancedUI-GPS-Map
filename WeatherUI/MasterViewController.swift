//
//  MasterViewController.swift
//  WeatherUI
//
//  Created by un1kalny on 20/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet var mainTableView: UITableView!
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    func cityInfoFromApi(currentCity: City) {
        var added = false
        var currentCity = currentCity
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Cities.instance.objects.count == 0) {
            var currentCity = City()
            currentCity.title = "San Francisco"
            currentCity.woeid = 2487956
            cityInfoFromApi(currentCity: currentCity)
            
            currentCity = City()
            currentCity.title = "London"
            currentCity.woeid = 44418
            cityInfoFromApi(currentCity: currentCity)
            
            currentCity = City()
            currentCity.title = "Oklahoma City"
            currentCity.woeid = 2464592
            cityInfoFromApi(currentCity: currentCity)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "addNewCity", sender: self)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                Cities.currentCity = Cities.instance.objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cities.instance.objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentCity = Cities.instance.objects[indexPath.row]
        cell.textLabel?.text = currentCity.title
        cell.detailTextLabel?.text = "\(Int(currentCity.allDaysWeather[0].theTemp!)) °C"

        if let unwrappedImage = currentCity.allDaysWeather[0].uiImage {
            cell.imageView?.image = unwrappedImage
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cities.instance.objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

