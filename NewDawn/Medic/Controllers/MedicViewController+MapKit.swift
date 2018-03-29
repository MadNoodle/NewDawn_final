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

