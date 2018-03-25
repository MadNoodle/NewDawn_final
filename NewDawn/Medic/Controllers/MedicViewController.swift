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
  
  // MARK: - Data
  var medics =  Therapist.getTherapist()
  
  
  // MARK: - Map Properties and outlets
  @IBOutlet weak var map: MKMapView!
  let locationManager = CLLocationManager()
  let regionRadius: CLLocationDistance = 100
  var coordinates: CLLocationCoordinate2D?
  
  
  // MARK: - Detail View Properties and outlets
  let identity: CGFloat = 0
  @IBOutlet weak var constraint: NSLayoutConstraint!
  @IBOutlet weak var infoStack: UIStackView!
  @IBOutlet weak var detailName: UILabel!
  @IBOutlet weak var detailAddress: UILabel!
  @IBOutlet weak var detailJob: UILabel!
  @IBOutlet weak var detailPhone: UILabel!
  
  // MARK: - LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Find a therapist"
    locationServiceSetup()
    loadMedicAnnotations()
    infoStack.isHidden = true
  }
  
  // MARK: - Location methods
  fileprivate func locationServiceSetup() {
    self.locationManager.delegate = self
    map.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    self.map.showsUserLocation = true
  }
  
  
  
  func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
    
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
    map.setRegion(coordinateRegion, animated: true)
    

    
  }
  
  
  fileprivate func loadMedicAnnotations() {
    for medic in medics {
      let annotation = MedicAnnotation(lat: medic.lat, lng: medic.lng, name: medic.name, image: "pin", subtitle: medic.adresse,tel: medic.tel, job: medic.profession)
      map.addAnnotation(annotation)
    }
  }
  
  // MARK: - Callout Methods
  fileprivate func calloutSetup(_ views: [Any]?, _ medicAnnotation: MedicAnnotation, _ view: MKAnnotationView) {
    let calloutView = views?[0] as! CustomCalloutView
    calloutView.nameLabel.text = medicAnnotation.title
    calloutView.addressLabel.text = medicAnnotation.subtitle
    let button = UIButton(frame: calloutView.detail.frame)
    button.addTarget(self,action: #selector(showDetail), for: .touchUpInside)
    calloutView.addSubview(button)
    
    calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height * 0.52)
    view.addSubview(calloutView)
  }
  
  @objc func showDetail(_ vc: UIViewController, sender: Any?) {
    constraint.constant = identity
  
    UIView.animate(withDuration: 0.5) {
      self.constraint.constant = self.map.frame.size.height / 3
      if self.coordinates != nil {
        self.centerMapOnLocation(self.coordinates!)
        self.infoStack.isHidden = false
      }
    }
  }
  
  
  // MARK: - Detail View Methods
  
  @IBAction func closeDetail(_ sender: UIButton) {
    UIView.animate(withDuration: 0.5) {
      self.constraint.constant = self.identity
      self.infoStack.isHidden = true
      self.locationManager.startUpdatingLocation()
    }
  }
  
  fileprivate func loadMedicDetails(_ view: MKAnnotationView) {
    let detail = view.annotation as! MedicAnnotation
    detailName.text = detail.title
    detailAddress.text = detail.subtitle
    detailJob.text = detail.job
    detailPhone.text = detail.tel
  }
}


// MARK: - <#MKMapViewDelegate#>
extension MedicViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    
    var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "pin")
    if annotationView == nil {
      annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "pin")
      annotationView?.canShowCallout = false
    } else {
      annotationView?.annotation = annotation
    }
    
    annotationView?.image = UIImage(named: "pin")
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if view.annotation is MKUserLocation {
      return
    }
    
    let medicAnnotation = view.annotation as! MedicAnnotation
    let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: self, options: nil)
    calloutSetup(views, medicAnnotation, view)
    map.setCenter((view.annotation?.coordinate)!, animated: true)
    coordinates = (view.annotation?.coordinate)!
    
    loadMedicDetails(view)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    if view.isKind(of: AnnotationView.self)
    {
      for subview in view.subviews
      {
        subview.removeFromSuperview()
      }
    }
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


