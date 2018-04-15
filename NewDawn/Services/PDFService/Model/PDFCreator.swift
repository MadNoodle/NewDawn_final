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

class PDFCreator{
  /// Array of views to be rendered in Pdf
  var pages : [UIView] = []
  /// Property that allows to iterate and generate multiple cells/pages in pdf
  var increment = 0
  var outputAsData: Bool = false
  
  func generatePDF(for pages: [UIView]) -> PDFPreviewViewController? {
    var controller: PDFPreviewViewController?
    do {
      // create the destination path
      let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("\(LocalisationString.attachmentName).pdf"))
      if outputAsData {
        // generate the pdf
        let data = try PDFGenerator.generated(by: pages)
        try data.write(to: dst, options: .atomic)
      } else {
        try PDFGenerator.generate(pages, to: dst)
      }
      
      // display in viewer
      controller = openPDFViewer(dst)
    } catch (let e) {
      print(e.localizedDescription)
    }
    return controller
  }
  
  fileprivate func openPDFViewer(_ pdfPath: URL) -> PDFPreviewViewController{
    let vc = PDFPreviewViewController(nibName: nil, bundle: nil)
    vc.setupWithURL(pdfPath)
    return vc
  }
  

  func pdfLayout(for challenges: [MockChallenge],mapView: MKMapView?,display: Layouts) -> [UIView]{
    generatePages(challenges, mapView, &pages, display: display)
    return pages
  }

  func generatePages(_ challenges: [MockChallenge], _ mapView: MKMapView?, _ pages: inout [UIView], display: Layouts) {
    // split array of challenges every x item
    
    let pagesItems: [[MockChallenge]] = challenges.chunks(5)
    
    // generate cells for each page
    for item in pagesItems {
        // pour chaque page je genere une vue au format A4 72dpi
      let pageView = UIView(frame: CGRect(x: 0, y: 0, width: 595, height: 842))
     
      pageView.backgroundColor = .white
      // dans cette vue je met 5 cells
      for id in item {
        var report : UIView?
        switch display {
        case .singleReport:
          report = generateDetail(for: id, in: pageView, with: mapView)
        case .multipleSummariesReport:
         report = generateCell(for: id, in: pageView, with: mapView)
        case .homepage:
          break
        }
      pageView.addSubview(report!)
        increment += 1
      }
      
      pages.append(pageView)
    }
  }
  
  func generateDetail(for id: MockChallenge, in pageView: UIView,with mapView: MKMapView?) -> UIView {
    // Instantiate Detail View
    let detailDisplay =  SingleChallengeExportView()
    
    // set frame full page
    detailDisplay.frame = CGRect(x: 0, y: 0 , width: pageView.frame.width, height: pageView.frame.height)
    // Populate with info
    
   
    detailDisplay.titleLabel.text = id.title
    detailDisplay.dateLabel.text = id.date.convertToString(format: .day)
    detailDisplay.anxietyLvl.text = "Anxiety level: \(String(id.anxietyLevel))"
    detailDisplay.benefit.text = "Benefit level: \(String(id.benefitLevel))"

    if id.comment != nil {
      detailDisplay.comments.text = id.comment
    } else {
      detailDisplay.comments.text = "No comment"
    }

    if let track = mapView {
      detailDisplay.map.image = UIImage(view:track)

    }
    return detailDisplay
  }
  
  func generateCell(for id: MockChallenge, in pageView: UIView,with mapView: MKMapView?) -> UIView {
    
    // Instantitate Cell
    let cell = ReportCellView()
    // UIConstants
    let numberOfitems = CGFloat(4)
    let offset: CGFloat = 8
    let cellHeigth: CGFloat = pageView.frame.width / numberOfitems
    
    // set size
    cell.frame = CGRect(x: 0, y: CGFloat(increment) * cellHeigth + ( 2 * offset), width: pageView.frame.width, height: cellHeigth)
    
    // populate
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
   return cell
  }
}
