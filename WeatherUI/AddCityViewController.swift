//
//  AddCityViewController.swift
//  WeatherUI
//
//  Created by un1kalny on 21/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var cityNameInput: UITextField!
    
    @objc
    func addCity() -> Void {
        
        //Cities.instance.objects.append(newCity)
        //performSegue(withIdentifier: backToMainView, sender: self)
    }
    
    @IBAction func cityNameInputChanged(_ sender: UITextField!) {
        let urlString = URL(string: "https://www.metaweather.com/api/location/search/?query=\(sender.text!)")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        City(json: json as! [[String : Any]])
                    }
                }
                print(City.listOfCities)
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
