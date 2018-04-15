///**
/**
NewDawn
Created by: Mathieu Janneau on 27/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class ObjectiveCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var label: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
    label.layer.shadowColor = UIColor.black.cgColor
    label.layer.shadowRadius = 3.0
    label.layer.shadowOpacity = 1.0
    label.layer.shadowOffset = CGSize(width: 4, height: 4)
    label.layer.masksToBounds = false
        // Initialization code
    }

}
