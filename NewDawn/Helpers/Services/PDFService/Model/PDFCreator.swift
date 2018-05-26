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

enum Layouts {
  case singleReport
  case multipleSummariesReport
  case homepage
}

class PDFCreator {
  /// Array of views to be rendered in Pdf
  var pages: [UIView] = []
  /// Property that allows to iterate and generate multiple cells/pages in pdf
  var increment = 0
  var outputAsData: Bool = false
  
  func scrollViewToPdf(data: NSData) -> PDFPreviewViewController? {
    var controller: PDFPreviewViewController?
    do {
      // create the destination path
      let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("Newdawn.pdf"))
    
        // generate the pdf
        try data.write(to: dst, options: .atomicWrite)
     
      
      // display in viewer
      controller = openPDFViewer(dst)
    } catch let error {
      print(error.localizedDescription)
    }
    return controller
  }
  
  func generatePDF(for pages: [UIView]) -> PDFPreviewViewController? {
    var controller: PDFPreviewViewController?
    do {
      // create the destination path
      let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("Newdawn.pdf"))
      if outputAsData {
        // generate the pdf
        let data = try PDFGenerator.generated(by: pages)
        try data.write(to: dst, options: .atomic)
      } else {
        try PDFGenerator.generate(pages, to: dst)
      }
      
      // display in viewer
      controller = openPDFViewer(dst)
    } catch let error {
      print(error.localizedDescription)
    }
    return controller
  }
  
  func openPDFViewer(_ pdfPath: URL) -> PDFPreviewViewController {
    let controller = PDFPreviewViewController(nibName: nil, bundle: nil)
    controller.setupWithURL(pdfPath)
    return controller
  }

  func pdfLayout(for challenges: [Challenge], mapView: MKMapView?, display: Layouts) -> [UIView] {
    generatePages(challenges, mapView, &pages, display: display)
    return pages
  }

  func generatePages(_ challenges: [Challenge], _ mapView: MKMapView?, _ pages: inout [UIView], display: Layouts) {
    // split array of challenges every x item
    
    let pagesItems: [[Challenge]] = challenges.chunks(5)
    
    // generate cells for each page
    for item in pagesItems {
        // pour chaque page je genere une vue au format A4 72dpi
      let pageView = UIView(frame: CGRect(x: 0, y: 0, width: 595, height: 842))
     
      pageView.backgroundColor = .white
      // dans cette vue je met 5 cells
      for idType in item {
        var report: UIView?
        switch display {
        case .singleReport:
          report = generateDetail(for: idType, in: pageView, with: mapView)
        case .multipleSummariesReport:
         report = generateCell(for: idType, in: pageView, with: mapView)
        case .homepage:
          break
        }
      pageView.addSubview(report!)
        increment += 1
      }
      
      pages.append(pageView)
    }
  }
  
  func generateDetail(for challenge: Challenge, in pageView: UIView, with mapView: MKMapView?) -> UIView {
    // Instantiate Detail View
    let detailDisplay =  SingleChallengeExportView()
    
    // set frame full page
    detailDisplay.frame = CGRect(x: 0, y: 0, width: pageView.frame.width, height: pageView.frame.height)
    // Populate with info
    detailDisplay.titleLabel.text = challenge.name
    let date = Date(timeIntervalSince1970: challenge.dueDate)
    detailDisplay.dateLabel.text = date.convertToString(format: .day)
    detailDisplay.anxietyLvl.text = "Anxiety level: \(String(challenge.anxietyLevel))"
    detailDisplay.benefit.text = "Benefit level: \(String(challenge.benefitLevel))"

    if challenge.comment != nil {
      detailDisplay.comments.text = challenge.comment
    } else {
      detailDisplay.comments.text = "No comment"
    }

    if let track = mapView {
      detailDisplay.map.image = UIImage(view: track)

    }
    return detailDisplay
  }
  
  func generateCell(for challenge: Challenge, in pageView: UIView, with mapView: MKMapView?) -> UIView {
    
    // Instantitate Cell
    let cell = ReportCellView()
    // UIConstants
    let numberOfitems = CGFloat(4)
    let offset: CGFloat = 8
    let cellHeigth: CGFloat = pageView.frame.width / numberOfitems
    
    // set size
    cell.frame = CGRect(x: 0, y: CGFloat(increment) * cellHeigth + ( 2 * offset), width: pageView.frame.width, height: cellHeigth)
    
    // populate
    cell.titleLabel.text = challenge.name
     let date = Date(timeIntervalSince1970: challenge.dueDate)
    cell.dateLabel.text = date.convertToString(format: .day)
    cell.anxietyLvl.text = "Anxiety level: \(String(challenge.anxietyLevel))"
    cell.benefit.text = "Benefit level: \(String(challenge.benefitLevel))"
   
    if challenge.comment != nil {
      cell.comments.text = challenge.comment
    } else {
      cell.comments.text = "No comment"
    }
    
    if let track = mapView {
      cell.map.image = UIImage(view: track)
      
    }
   return cell
  }
}
