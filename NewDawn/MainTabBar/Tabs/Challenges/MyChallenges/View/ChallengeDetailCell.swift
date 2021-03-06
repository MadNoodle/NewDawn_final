///**
/**
NewDawn
Created by: Mathieu Janneau on 04/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class ChallengeDetailCell: UITableViewCell {

  @IBOutlet weak var statusIndicator: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
