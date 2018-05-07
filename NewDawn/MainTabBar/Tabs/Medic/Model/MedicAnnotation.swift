///**
/**
NewDawn
Created by: Mathieu Janneau on 24/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import MapKit
import CoreLocation

final class MedicAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var image: String
  var subtitle: String?
  var tel: String?
  var job: String?
  
  init(lat: String, lng: String, name: String, image: String, subtitle: String, tel: String, job: String) {
    let degLat: CLLocationDegrees = CLLocationDegrees(lat)!
    let degLng: CLLocationDegrees = CLLocationDegrees(lng)!
    self.coordinate = CLLocationCoordinate2D(latitude: degLat, longitude: degLng)
    self.title = name
    self.subtitle = subtitle
    self.image = image
    self.tel = tel
    self.job = job
    super.init()
  }
}
