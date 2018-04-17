///**
/**
NewDawn
Created by: Mathieu Janneau on 25/03/2018
Copyright (c) 2018 Mathieu Janneau
*/

import UIKit
import MapKit

class CustomCalloutView : UIView {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var detail: UILabel!
  override func awakeFromNib() {
    self.layer.cornerRadius = 5.0
    self.layer.masksToBounds = true
    detail.layer.cornerRadius = 5.0
    detail.layer.masksToBounds = true
  }
}
