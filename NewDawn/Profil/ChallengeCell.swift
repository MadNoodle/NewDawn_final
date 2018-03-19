//
//  ChallengeCell.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 16/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class ChallengeCell: UITableViewCell {

  @IBOutlet weak var timeContainer: UIView!
  @IBOutlet weak var objectiveIcon: UIImageView!
  @IBOutlet weak var challengeTime: UILabel!
  @IBOutlet weak var challengeState: UIImageView!
  @IBOutlet weak var challengeDescription: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    timeContainerSetup()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  fileprivate func timeContainerSetup() {
    timeContainer.layer.cornerRadius = 12.0
    timeContainer.layer.borderColor = ColorTemplate.blueGray.cgColor
    timeContainer.layer.borderWidth = 1.0
  }
}
