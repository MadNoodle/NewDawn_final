///**
/**
NewDawn
Created by: Mathieu Janneau on 07/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import CoreLocation
import MapKit

extension ProgressViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // TRACKING FEATURE
    for newLocation in locations {
      // check last update to see if the difference is large enought to create a new tracking point
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
      }
      locationList.append(newLocation)
    }
    
    // CUSTOMIZE ANNOTATION
    let location = locations.last
    // Set Center to users Location
    let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
    // Define scale
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    self.mapView.setRegion(region, animated: true)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Errors " + error.localizedDescription)
  }
}
