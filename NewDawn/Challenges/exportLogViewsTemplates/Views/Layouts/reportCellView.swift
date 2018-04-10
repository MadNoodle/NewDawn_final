///**
/**
NewDawn
Created by: Mathieu Janneau on 08/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit

@IBDesignable
class ReportCellView: UIView {
  
  @IBOutlet var contentView: ReportCellView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var comments: UITextView!
  @IBOutlet weak var map: UIImageView!
  @IBOutlet weak var anxietyLvl: UILabel!
  @IBOutlet weak var benefit: UILabel!
  @IBOutlet weak var feltAnxiety: UILabel!
  
  override init(frame:CGRect){
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func commonInit() {
  Bundle.main.loadNibNamed("reportCellView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
  }
}
