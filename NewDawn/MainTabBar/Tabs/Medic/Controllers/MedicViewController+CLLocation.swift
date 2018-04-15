///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace
import UIKit
import MapKit

// MARK: - <#CLLocationManagerDelegate#>
extension MedicViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    // Set Center to users Location
    let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
    // Define scale
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    self.map.setRegion(region, animated: true)
    self.locationManager.stopUpdatingLocation()
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Errors " + error.localizedDescription)
  }
  
}
