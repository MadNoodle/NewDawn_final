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
  
  // //////////// //
  // MARK: - DATA //
  // //////////// //
  
  var medics =  Therapist.getTherapist()
  
  // ////////////////////////////////// //
  // MARK: - Map Properties and outlets //
  // ////////////////////////////////// //
  
  @IBOutlet weak var map: MKMapView!
  let locationManager = CLLocationManager()
  let regionRadius: CLLocationDistance = 100
  var coordinates: CLLocationCoordinate2D?
  
  // ////////////////////////////////////////// //
  // MARK: - Detail View Properties and outlets //
  // ////////////////////////////////////////// //
  
  let identity: CGFloat = 0
  @IBOutlet weak var constraint: NSLayoutConstraint!
  @IBOutlet weak var infoStack: UIStackView!
  @IBOutlet weak var detailName: UILabel!
  @IBOutlet weak var detailAddress: UILabel!
  @IBOutlet weak var detailJob: UILabel!
  @IBOutlet weak var detailPhone: UILabel!
  
  // ///////////////////////// //
  // MARK: - LifeCycle Methods //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationServiceSetup()
    loadMedicAnnotations()
    infoStack.isHidden = true
  }
  
  // ///////////////////////// //
  // MARK: - Location methods  //
  // ///////////////////////// //
  
  fileprivate func locationServiceSetup() {
    self.locationManager.delegate = self
    map.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    self.map.showsUserLocation = true
  }
  

  func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
    //set center and zoom level
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
    map.setRegion(coordinateRegion, animated: true)
    
  }
 
  fileprivate func loadMedicAnnotations() {
    // create annotaions for all therapist
    for medic in medics {
      let annotation = MedicAnnotation(lat: medic.lat, lng: medic.lng, name: medic.name, image: "pin", subtitle: medic.adresse,tel: medic.tel, job: medic.profession)
      map.addAnnotation(annotation)
    }
  }
  
  // /////////////////////// //
  // MARK: - Callout Methods //
  // /////////////////////// //
  
  func calloutSetup(_ views: [Any]?, _ medicAnnotation: MedicAnnotation, _ view: MKAnnotationView) {
    // Instantiate Custom CallOut
    let calloutView = views?[0] as! CustomCalloutView
    calloutView.nameLabel.text = medicAnnotation.title
    calloutView.addressLabel.text = medicAnnotation.subtitle
    
    // add detail button
    let button = UIButton(frame: calloutView.detail.frame)
    // add action
    button.addTarget(self,action: #selector(showDetail), for: .touchUpInside)
    calloutView.addSubview(button)
    
    // CallOut position
    calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height * 0.52)
    view.addSubview(calloutView)
  }
  


  
  // /////////////////////////// //
  // MARK: - Detail View Methods //
  // /////////////////////////// //
  
  @objc func showDetail(_ vc: UIViewController, sender: Any?) {
    // initial constraint
    constraint.constant = identity
    
    UIView.animate(withDuration: 0.5) {
      // depliy detailView
      self.constraint.constant = self.infoStack.frame.height + 50
      if self.coordinates != nil {
        // Center map and zoom to conform new frame
        self.centerMapOnLocation(self.coordinates!)
        self.infoStack.isHidden = false
      }
    }
  }
  func loadMedicDetails(_ view: MKAnnotationView) {
    // grab info from annotations
    let detail = view.annotation as! MedicAnnotation
    // populate detail view
    detailName.text = detail.title
    detailAddress.text = detail.subtitle
    detailJob.text = detail.job
    detailPhone.text = detail.tel
  }
  
  @IBAction func closeDetail(_ sender: UIButton) {
    // animate to initial
    UIView.animate(withDuration: 0.5) {
      self.constraint.constant = self.identity
      self.infoStack.isHidden = true
      self.locationManager.startUpdatingLocation()
    }
  }
  
  @IBAction func callTherapist(_ sender: UIButton) {
    
    // remove unwanted characters to conform phone number string
    var formattedNumber = detailPhone.text!
    let forbiddenCharacters = [" ", "-", "."]
    for char in forbiddenCharacters {
      formattedNumber = formattedNumber.replacingOccurrences(of: char , with: "")
      
    }
    // Open phone app and send number
    guard let number = URL(string: "tel://" + formattedNumber) else { return }
    UIApplication.shared.open(number)
  }
  
  @IBAction func shareDetail(_ sender: UIButton) {
    
    // text to share
    let text = "\(String(describing: detailName.text!)) \n \(String(describing: detailAddress.text!)) \n \(String(describing: detailJob.text!)) \n \(String(describing: detailPhone.text!))"
    
    // set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    
  }
  
  @IBAction func getDirection(_ sender: UIButton) {
    // set zoom level
    let regionDistance:CLLocationDistance = 1000;
    let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates!, regionDistance, regionDistance)
    
    let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
    
    // convert coordinates in placemeark for maps
    let placemark = MKPlacemark(coordinate: coordinates!)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = detailName.text!
    mapItem.openInMaps(launchOptions: options)
    
  }
  

}




