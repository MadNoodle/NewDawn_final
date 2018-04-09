///**
/**
 NewDawn
 Created by: Mathieu Janneau on 08/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit
import MapKit
import PDFGenerator

class PDFLayout{
  

  var pages : [UIView] = []

  func pdfLayout(for challenges: [MockChallenge],mapView: MKMapView?) -> [UIView]{
    
    generatePages(challenges, mapView, &pages)
    return pages
  }

  fileprivate func generatePages(_ challenges: [MockChallenge], _ mapView: MKMapView?, _ pages: inout [UIView]) {
    
    let offset: CGFloat = 8
    // split array of challenges every x item
    
    let pagesItems: [[MockChallenge]] = challenges.chunks(5)
    let numberOfitems = CGFloat(4)
    // generate cells for each page
    for item in pagesItems {
      
      // pour chaque page je genere une vue au format A4 72dpi
      
      let pageView = UIView(frame: CGRect(x: 0, y: 0, width: 595, height: 842))
      pageView.backgroundColor = .white
      var increment = 0
      // dans cette vue je met 5 cells
      for id in item {
        let cellHeigth: CGFloat = pageView.frame.width / numberOfitems
        let cell = ReportCellView()
        cell.frame = CGRect(x: 0, y: CGFloat(increment) * cellHeigth + ( 2 * offset), width: pageView.frame.width, height: cellHeigth)
        cell.titleLabel.text = id.title
        cell.dateLabel.text = id.date.convertToString(format: .day)
        cell.anxietyLvl.text = "Anxiety level: \(String(id.anxietyLevel))"
        cell.benefit.text = "Benefit level: \(String(id.benefitLevel))"
        if id.comment != nil {
          cell.comments.text = id.comment
        } else {
          cell.comments.text = "No comment"
        }
        
        if let track = mapView {
          cell.map.image = UIImage(view:track)

        }
        

        pageView.addSubview(cell)
        increment += 1
      }
      
      pages.append(pageView)
    }
  }
}
