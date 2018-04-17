///**
/**
NewDawn
Created by: Mathieu Janneau on 11/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit

class HomepageExportView: UIView {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var capture: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("homepageExportView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
  }
}
