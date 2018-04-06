///**
/**
 NewDawn
 Created by: Mathieu Janneau on 06/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import MapKit
import CoreLocation

class ProgressViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
  // grab the challenge
  
  var challenge: MockChallenge?
  
  let locationManager = CLLocationManager()
  // instantiate timer
  
  @IBOutlet weak var challengeLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timerDisplay: UILabel!
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    challenge?.challengeLong = 2.3
    challenge?.challengeLat = 48.876965
    // add share button to navigation
    
    // todo white color button
    let rightButton: UIBarButtonItem =
      UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain , target: self, action: #selector(shareChallenge))
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.rightBarButtonItem = rightButton
    
    // load title
    if let currentChallenge = challenge {
      challengeLabel.text = currentChallenge.title
      dateLabel.text = currentChallenge.date
    }
    
    
    // load map
    self.locationManager.delegate = self
    mapView.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    self.mapView.showsUserLocation = true
    // load annotation for destination
    if let destination = challenge {
      let challengeDestination: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: destination.challengeLat!, longitude: destination.challengeLong!)
      let annotation = MKPointAnnotation()
      annotation.coordinate = challengeDestination
      
      mapView.addAnnotation(annotation)
    }
    
    
    
  }
  
  
  @IBAction func startChallenge(_ sender: UIButton) {
    // start tracking
    
    // start Timer
  }
  
  @IBAction func invalidateChallenge(_ sender: UIButton) {
    challenge?.state = false
    
  }
  @IBAction func validateChallenge(_ sender: UIButton) {
    // change state of challenge
    challenge?.state = true
    // stop timer
  }
  
  @objc func shareChallenge() {
    print("share")  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    // Set Center to users Location
    let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
    // Define scale
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    self.mapView.setRegion(region, animated: true)
    self.locationManager.stopUpdatingLocation()
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Errors " + error.localizedDescription)
  }
  
  
  // Set Flag image for destination
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    // Assign custom Annotation
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "flag")
    if annotationView == nil {
      annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "flag")
      // hide callOut on pop
      annotationView?.canShowCallout = false
    } else {
      annotationView?.annotation = annotation
    }
    
    // Custom pin image
    annotationView?.image = UIImage(named: "flag")
    return annotationView
  }
  
}

