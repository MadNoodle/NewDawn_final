///**
/**
 NewDawn
 Created by: Mathieu Janneau on 26/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import JTAppleCalendar

/// Date cell
class CalendarCell: JTAppleCell {
  
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var eventDotView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Yellow bubble to wrap selected cell
    selectedView.layer.cornerRadius = 17.5
    selectedView.layer.masksToBounds = true
    selectedView.isHidden = true
  }
  
}
