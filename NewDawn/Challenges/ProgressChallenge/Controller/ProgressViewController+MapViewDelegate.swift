///**
/**
NewDawn
Created by: Mathieu Janneau on 07/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import MapKit

extension ProgressViewController : MKMapViewDelegate{
  
  // Set Flag image for destination
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    // Customize annotation
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
  
  // Path Overlay Drawing
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = UIConfig.lightGreen
    renderer.lineWidth = 5
    return renderer
  }
}
