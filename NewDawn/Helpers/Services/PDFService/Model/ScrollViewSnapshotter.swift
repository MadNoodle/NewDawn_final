///**
/**
NewDawn
Created by: Mathieu Janneau on 25/05/2018
Copyright (c) 2018 Mathieu Janneau
*/

import UIKit

class ScrollViewSnapshotter: NSObject {
  
  func PDFWithScrollView(scrollview: UIScrollView) -> NSData {
    

    let pageDimensions = scrollview.bounds
    

    let pageSize = pageDimensions.size
    let totalSize = scrollview.contentSize
    
    let numberOfPagesThatFitHorizontally = Int(ceil(totalSize.width / pageSize.width))
    let numberOfPagesThatFitVertically = Int(ceil(totalSize.height / pageSize.height))
    

    
    let outputData = NSMutableData()
    
    UIGraphicsBeginPDFContextToData(outputData, pageDimensions, nil)

    
    let savedContentOffset = scrollview.contentOffset
    let savedContentInset = scrollview.contentInset
    
    scrollview.contentInset = UIEdgeInsets.zero
    

    if let context = UIGraphicsGetCurrentContext()
    {
      for indexHorizontal in 0 ..< numberOfPagesThatFitHorizontally
      {
        for indexVertical in 0 ..< numberOfPagesThatFitVertically
        {
          
          
          UIGraphicsBeginPDFPage()

          let offsetHorizontal = CGFloat(indexHorizontal) * pageSize.width
          let offsetVertical = CGFloat(indexVertical) * pageSize.height
          
          scrollview.contentOffset = CGPoint(x: offsetHorizontal, y: offsetVertical)
          context.translateBy(x: -offsetHorizontal, y: -offsetVertical)  // NOTE: Negative offsets
          
        
          
          scrollview.layer.render(in: context)
        }
      }
    }
    
   
    
    UIGraphicsEndPDFContext()
 
    
    scrollview.contentInset = savedContentInset
    scrollview.contentOffset = savedContentOffset
    

    
    return outputData
  }
}
