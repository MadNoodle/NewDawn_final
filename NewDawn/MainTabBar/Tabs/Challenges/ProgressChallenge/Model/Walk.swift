///**
/**
NewDawn
Created by: Mathieu Janneau on 07/04/2018
Copyright (c) 2018 Mathieu Janneau
*/

import Foundation
import CoreLocation

struct Walk {
  var startPoint: CLLocationCoordinate2D?
  var endPoint: CLLocationCoordinate2D?
}

struct Location {
  var timeStamp: Double?
  var latitude: Double?
  var longitude: Double?
}
