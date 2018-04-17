///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace
import UIKit
import MapKit

// MARK: - <#MKMapViewDelegate#>
extension MedicViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    // Assign custom Annotation
    var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "pin")
    if annotationView == nil {
      annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "pin")
      // hide callOut on pop
      annotationView?.canShowCallout = false
    } else {
      annotationView?.annotation = annotation
    }
    
    // Custom pin image
    annotationView?.image = UIImage(named: "pin")
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if view.annotation is MKUserLocation {
      return
    }
    
    // pop call out when annotation is selected
    if let medicAnnotation = view.annotation as? MedicAnnotation {
    let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: self, options: nil)
    calloutSetup(views, medicAnnotation, view)
    // recenter map on selected annotation
    map.setCenter((view.annotation?.coordinate)!, animated: true)
    coordinates = (view.annotation?.coordinate)!
    
    // grab data from annotation and prepare it for detailView
    loadMedicDetails(view)}
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    // remove annotation and callouts
    if view.isKind(of: AnnotationView.self) {
      for subview in view.subviews {
        subview.removeFromSuperview()
      }
    }
  }
}
