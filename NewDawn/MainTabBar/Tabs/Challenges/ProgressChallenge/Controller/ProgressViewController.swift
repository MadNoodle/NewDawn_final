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
import Firebase
import FirebaseDatabase
import FirebaseStorage

protocol EditableChallenge {
  var challengeToSend: TempChallenge? {get set}
  var challengeKey: String? {get set}
}

/// This class handles a challenge progess. It allows
/// the user to declare a challenge done or failed,
/// a track is gps position during the challenge, write comments,
/// and share a pdf report via email
class ProgressViewController: UIViewController, EditableChallenge {
  var challengeKey: String?
  
  var challengeToSend: TempChallenge?

  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var outputAsData: Bool = false
  // grab the challenge
  var challenge: TempChallenge?

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
    shouldDrawUI()
    handleMapViewSettings()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // stop CLLocation from fetcing GPS coordinates
    locationManager.stopUpdatingLocation()
    
    UIView.animate(withDuration: 0.5) {
      self.startButtonHeight.constant = 37
    }
  }
  
  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  /// Heigth of start button. Used make the button disappear and
  /// realign stackview
  @IBOutlet weak var startButtonHeight: NSLayoutConstraint!
    
  /// start challenge button action
  @IBAction func startChallenge(_ sender: UIButton) {
    // tracking
    shouldStartTracking()
    
    // remove start button
    UIView.animate(withDuration: 0.5) {
      self.startButtonHeight.constant = 0
    }
  }
  
  /// Used to stop the challenge progress and declare it failed
  @IBAction func invalidateChallenge(_ sender: UIButton) {
    challenge?.isDone = 0
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
    mapView.showsUserLocation = false
  }
  
  /// Instatiate the challenge helper object
  let congratulation = Congratulation()
  
  /// Used to stop the current challenge progress and declare it done
  @IBAction func validateChallenge(_ sender: UIButton) {
    // change state of challenge
    congratulation.showSettings()
    
    challenge?.isDone = 1
    challenge?.comment = textView.text
    let screenshot = UIImage(view:mapView)
    // convert image to data
    if let mapImage = UIImagePNGRepresentation(screenshot){
    // store in firebase
    let storageRef = Storage.storage().reference().child("myImage.png")
    storageRef.putData(mapImage, metadata: nil) { (metadata, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
    }
    challenge?.map = mapImage
    }

    
    locationManager.stopUpdatingLocation()
    mapView.showsUserLocation = false
  }
  
  /// Navigation Bar left button selector to share chalenge.
  /// it generates a PDF and open the previewer
  @objc func shareChallenge() {
    //send comment from text view to model
    challenge?.comment = textView.text
    guard let exercise = challenge else {return}
    //send comment from text view to model
    // instantiate pdfCreator
    let pdfCreator = PDFCreator()
    
    let pages = pdfCreator.pdfLayout(for: [exercise], mapView: mapView, display: .singleReport)
    if let controller = pdfCreator.generatePDF(for: pages) {
      present(controller, animated: true, completion: nil)
      
    }
  }
  
  @objc func editChallenge() {
   // guard let mission = challenge else {return}
    let editVc = EditChallengeViewController()
    editVc.delegate = self
    challengeToSend = challenge
   challengeKey = challenge?.key
    print(challengeKey!)

    self.navigationController?.pushViewController(editVc, animated: true)
  }
  
  // ////////////////// //
  // MARK: - UI METHODS //
  // ////////////////// //
  
  /// Draws all the UI elements
  fileprivate func shouldDrawUI() {
    
    // load title and date
    if let currentChallenge = challenge {
      challengeLabel.text = currentChallenge.name
      // Convert double to date
      let date = Date(timeIntervalSince1970: currentChallenge.dueDate)
      dateLabel.text = date.convertToString(format: .dayHourMinute)
    }
    
    
    // Set frame border for textView
    textView.layer.borderColor = UIConfig.blueGray.cgColor
    textView.layer.borderWidth = 1
    
    // add share button to navigation
    let rightButton: UIBarButtonItem =
      UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(editChallenge))

  
    // add share button to navigation
    let rightButton2: UIBarButtonItem =
      UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain, target: self, action: #selector(shareChallenge))
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.rightBarButtonItems = [rightButton2, rightButton]
  }
  
  // //////////////////////// //
  // MARK: - TRACKING METHODS //
  // //////////////////////// //
  
  /// Sets up all delegate and display settings for the MKMapView
  fileprivate func handleMapViewSettings() {
    // load map
    self.locationManager.delegate = self
    self.locationManager.allowsBackgroundLocationUpdates = true
    self.locationManager.pausesLocationUpdatesAutomatically = false
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.mapView.showsUserLocation = true
    mapView.delegate = self
    
    guard let center = locationManager.location?.coordinate else { return}
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    self.mapView.setRegion(region, animated: true)
    // load custom annotation for destination
    if let destination = challenge {
      guard let latitude = destination.destinationLat, let longitude = destination.destinationLong else { return}
      let challengeDestination: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:latitude , longitude: longitude)
      let annotation = MKPointAnnotation()
      annotation.coordinate = challengeDestination
      mapView.addAnnotation(annotation)
    }
  }
  
  /// Grab user coordinates each seconds and convert it to a graphic point
  fileprivate func shouldStartTracking() {
    // every ten meters grab a point
    self.locationManager.distanceFilter = 10
    // start tracking
    self.locationManager.startUpdatingLocation()
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
      self.handleDrawTrack()
    }
  }
  
  /// Grab user coordinates and convert it to a polyline track overlay forMapview
  private func handleDrawTrack() {
    // convert coodinates to draw path
    let coords: [CLLocationCoordinate2D] = locationList.map { location in
      return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    // draw
    mapView.add(MKPolyline(coordinates: coords, count: coords.count))
  }
  
}
