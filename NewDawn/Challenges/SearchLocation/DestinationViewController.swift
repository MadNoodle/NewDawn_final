///**
/**
NewDawn
Created by: Mathieu Janneau on 31/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import MapKit

class DestinationViewController: UIViewController, UISearchBarDelegate,MKMapViewDelegate {


  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    // Ignoring user
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    //create loading spinner
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    indicator.center = self.view.center
    indicator.hidesWhenStopped = true
    indicator.startAnimating()
    self.view.addSubview(indicator)
    
    // hide searchBar
    searchBar.resignFirstResponder()
    dismiss(animated: true, completion: nil)
    
    let searchRequest = MKLocalSearchRequest()
    searchRequest.naturalLanguageQuery = searchBar.text
    
    let activeSearch = MKLocalSearch(request: searchRequest)
    activeSearch.start { (response, error) in
      indicator.stopAnimating()
      UIApplication.shared.endIgnoringInteractionEvents()
      if response == nil {
        print("error")
      } else {
        
        // clear the map from annotations
        let annotations = self.map.annotations
        self.map.removeAnnotations(annotations)
        // fetching data
        if let latitude = response?.boundingRegion.center.latitude
        { if let longitude = response?.boundingRegion.center.longitude
       {
        // create Annotation
        let annotation = MKPointAnnotation()
        
        annotation.title = searchBar.text
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.map.addAnnotation(annotation)
        
        // Set Zoom 
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
        self.map.setRegion(region, animated: true)
        
          }
          
        }
      }
      
    }
    
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?  {
    
    if annotation is MKPointAnnotation {
      
      let identifier = "stopAnnotation"
      var pinView = map.dequeueReusableAnnotationView(withIdentifier: identifier)
      if pinView == nil {
        //println("Pinview was nil")
        
        //Create a plain MKAnnotationView if using a custom image...
        pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        pinView?.canShowCallout = true
        pinView?.image = UIImage(named: "pin")
      }
      else {
        //Unrelated to the image problem but...
        //Update the annotation reference if re-using a view...
        pinView?.annotation = annotation
      }
      
      return pinView
    }
    return nil
  }
  @IBOutlet weak var map: MKMapView!
  override func viewDidLoad() {
        super.viewDidLoad()
    // add search button to navBar
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchLocation))
    self.navigationItem.rightBarButtonItem = searchButton
    
    }

  @objc func searchLocation(_ sender: UIBarButtonItem){
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    present(searchController, animated: true, completion: nil)
    
  }

}
