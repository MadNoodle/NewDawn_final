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


class ProgressViewController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var outputAsData: Bool = false
  // grab the challenge
  var challenge: MockChallenge?
  
  // initiate walk for tracking route
  let walk = Walk()
  
  // Initiate location functionnality
  let locationManager = CLLocationManager()
  
  // Temporary store route points
  var locationList: [CLLocation] = []
  var seconds = 0
  var timer: Timer?
  var distance = Measurement(value: 0, unit: UnitLength.meters)
  // instantiate timer
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var challengeLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupMapView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    locationManager.stopUpdatingLocation()
    UIView.animate(withDuration: 0.5) {
      self.startButtonHeight.constant = 37
    }
  }
  
  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  @IBOutlet weak var startButtonHeight: NSLayoutConstraint!
  
  
  @IBAction func startChallenge(_ sender: UIButton) {
    startTracking()
    self.locationManager.distanceFilter = 10
    self.locationManager.startUpdatingLocation()
    UIView.animate(withDuration: 0.5) {
      self.startButtonHeight.constant = 0
    }
  }
  
  @IBAction func invalidateChallenge(_ sender: UIButton) {
    challenge?.state = false
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
    mapView.showsUserLocation = false
  }
  let congratulation = Congratulation()
  @IBAction func validateChallenge(_ sender: UIButton) {
    // change state of challenge
    
    congratulation.showSettings()
    challenge?.state = true
    locationManager.stopUpdatingLocation()
    mapView.showsUserLocation = false
  }
  
  @objc func shareChallenge() {
    //send comment from text view to model
    challenge?.comment = textView.text
    guard let exercise = challenge else {return}
    //send comment from text view to model
    // instantiate pdfCreator
    let pdfCreator = PDFCreator()
    
    let pages = pdfCreator.pdfLayout(for: [exercise], mapView: nil, display: .singleReport)
    if let vc = pdfCreator.generatePDF(for: pages){
      present(vc, animated: true, completion: nil)
      
    }
  }
  
  
  // ////////////////// //
  // MARK: - UI METHODS //
  // ////////////////// //
  
  fileprivate func setupUI() {
    
    // load title and date
    if let currentChallenge = challenge {
      challengeLabel.text = currentChallenge.title
      dateLabel.text = currentChallenge.date.convertToString(format: .dayHourMinute)
    }
    // Mock challenge Destination
    challenge?.challengeLong = 2.3
    challenge?.challengeLat = 48.876965
    // Set frame border for textView
    textView.layer.borderColor = UIConfig.blueGray.cgColor
    textView.layer.borderWidth = 1
    
    // add share button to navigation
    let rightButton: UIBarButtonItem =
      UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain , target: self, action: #selector(shareChallenge))
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  // //////////////////////// //
  // MARK: - TRACKING METHODS //
  // //////////////////////// //
  
  fileprivate func setupMapView() {
    // load map
    self.locationManager.delegate = self
    self.locationManager.allowsBackgroundLocationUpdates = true
    self.locationManager.pausesLocationUpdatesAutomatically = false
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.mapView.showsUserLocation = true
    mapView.delegate = self
    
    // load annotation for destination
    if let destination = challenge {
      let challengeDestination: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: destination.challengeLat!, longitude: destination.challengeLong!)
      let annotation = MKPointAnnotation()
      annotation.coordinate = challengeDestination
      mapView.addAnnotation(annotation)
    }
  }
  
  fileprivate func startTracking() {
    // start tracking
    // initialize the timer
    seconds = 0
    // initialize distance
    distance = Measurement(value: 0, unit: UnitLength.meters)
    // purge the data
    locationList.removeAll()
    
    // update location each seconds
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.seconds += 1
      // draw path
      self.drawTrack()
    }
  }
  
  private func drawTrack()  {
    // convert coodinates to draw path
    let coords: [CLLocationCoordinate2D] = locationList.map { location in
      return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    // draw
    mapView.add(MKPolyline(coordinates: coords, count: coords.count))
  }
  
  
  
}

