//
//  MedicViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 18/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MedicViewController: UIViewController {
  
  var medics =  Therapist.getTherapist()
  let locationManager = CLLocationManager()
  
  @IBOutlet weak var map: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Find a therapist"
    self.locationManager.delegate = self
    map.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    self.map.showsUserLocation = true
    loadMedicAnnotations()
  }
  
  fileprivate func loadMedicAnnotations() {
    for medic in medics {
      let annotation = MedicAnnotation(lat: medic.lat, lng: medic.lng, name: medic.name, image: "pin", subtitle: medic.adresse)
      map.addAnnotation(annotation)
    }
  }
}


// MARK: - <#MKMapViewDelegate#>
extension MedicViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
  {
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Anno")
    if annotationView == nil {
      //annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "pokemonIdentitfier")
      annotationView = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: "Anno")
    }

    if let cpa = annotation as? MedicAnnotation {
      annotationView!.image = UIImage(named: cpa.image)
      (annotationView as! CustomAnnotationView).nameLabel.text = "\(cpa.title!) \n \(cpa.subtitle!) "
    }
    let btn = UIButton(type: .detailDisclosure)
    annotationView!.rightCalloutAccessoryView = btn
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    (view as! CustomAnnotationView).nameLabel.isHidden = true
  }
}

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


