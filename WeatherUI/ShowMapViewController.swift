//
//  ShowMapViewController.swift
//  WeatherUI
//
//  Created by un1kalny on 30/10/2018.
//  Copyright © 2018 KacperSzalwa. All rights reserved.
//

import MapKit

class ShowMapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var latt_long = Cities.currentCity!.latt_long!.replacingOccurrences(of: " ", with: "").split(separator: ",")
        let latt = Double(latt_long[0])!
        let long = Double(latt_long[1])!
        let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: long)
        mapView.setCenter(coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
