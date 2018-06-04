///**
/**
NewDawn
Created by: Mathieu Janneau on 27/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import JTAppleCalendar

/// Calendar Header cell
class HeaderView: JTAppleCollectionReusableView {

  @IBOutlet weak var mon: UILabel!
  @IBOutlet weak var tue: UILabel!
  @IBOutlet weak var wed: UILabel!
  @IBOutlet weak var thu: UILabel!
  @IBOutlet weak var fri: UILabel!
  @IBOutlet weak var sat: UILabel!
  @IBOutlet weak var sun: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
