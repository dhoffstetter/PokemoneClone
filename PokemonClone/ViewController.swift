//
//  ViewController.swift
//  PokemonClone
//
//  Created by Diane Hoffstetter on 9/29/16.
//  Copyright © 2016 Dumb Blonde Software. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var mapView: MKMapView!
  
  var manager = CLLocationManager()
  
  var updateCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    manager.delegate = self
    
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      print("Ready to go!")
      mapView.showsUserLocation = true
      manager.startUpdatingLocation()
      
      Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
        
        // Spawn a Pokemon
        
        print("Spawn")
        
        if let coord = self.manager.location?.coordinate {
          let anno = MKPointAnnotation()
          anno.coordinate = coord
          let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
          let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
          anno.coordinate.latitude += randoLat
          anno.coordinate.longitude += randoLon
          
          self.mapView.addAnnotation(anno)
        }
      })

    }
    else {
      manager.requestWhenInUseAuthorization()

    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if updateCount < 3 {
      
      let region = MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 200, 200)
      mapView.setRegion(region, animated: false)
      updateCount += 1
    }
    else {
      manager.stopUpdatingLocation()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBAction func centerTapped(_ sender: AnyObject) {
    
    if let coord = manager.location?.coordinate {
    let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
    mapView.setRegion(region, animated: true)
    }
  }
}

