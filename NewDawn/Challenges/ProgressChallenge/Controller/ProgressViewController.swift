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
import PDFGenerator

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
    
    // Mock challenge Destination
    challenge?.challengeLong = 2.3
    challenge?.challengeLat = 48.876965
    textView.layer.borderColor = UIConfig.blueGray.cgColor
    textView.layer.borderWidth = 1
    // add share button to navigation
    let rightButton: UIBarButtonItem =
      UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain , target: self, action: #selector(shareChallenge))
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.rightBarButtonItem = rightButton
    
    // load title
    if let currentChallenge = challenge {
      challengeLabel.text = currentChallenge.title
      dateLabel.text = currentChallenge.date.convertToString(format: .dayHourMinute)
    }
    
    
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
    challenge?.comment = textView.text
    let pdfCreator = PDFLayout()
    guard let exercise = challenge else {return}
    let pages = pdfCreator.pdfLayout(for: [exercise, exercise,exercise,exercise,exercise,exercise], mapView: mapView)
    generatePDF(for: pages)
 }
  
  
  // //////////////////////// //
  // MARK: - PDF EXPORT METHODS //
  // //////////////////////// //
  
  func generatePDF(for pages: [UIView]) {
    do {
      let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("sample1.pdf"))
      if outputAsData {
        let data = try PDFGenerator.generated(by: pages)
        try data.write(to: dst, options: .atomic)
      } else {
        try PDFGenerator.generate(pages, to: dst)
      }
      openPDFViewer(dst)
    } catch (let e) {
      print(e)
    }
  }
  
  fileprivate func openPDFViewer(_ pdfPath: URL) {

    let vc = PDFPreviewViewController(nibName: nil, bundle: nil)
    vc.setupWithURL(pdfPath)
    present(vc, animated: true, completion: nil)
  }
 
  

  
  // //////////////////////// //
  // MARK: - TRACKING METHODS //
  // //////////////////////// //
  
  fileprivate func startTracking() {
    // start tracking
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    locationList.removeAll()
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.seconds += 1
      self.drawTrack()
    }
  }
  
  private func drawTrack()  {

    let coords: [CLLocationCoordinate2D] = locationList.map { location in
      return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    print(coords)
    mapView.add(MKPolyline(coordinates: coords, count: coords.count))
  }
  


}

