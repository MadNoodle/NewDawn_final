///**
/**
NewDawn
Created by: Mathieu Janneau on 24/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

protocol MedicDetailMapViewDelegate: class {
  func detailsRequestedForPerson(person: Therapist)
}
class MedicView: UIView {

  @IBOutlet weak var detailButton: UIButton!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var adressLabel: UILabel!
  
  var therapist: Therapist?
  weak var delegate: MedicDetailMapViewDelegate?
  @IBAction func seeDetail(_ sender: UIButton) {
    delegate?.detailsRequestedForPerson(person: therapist!)
  }
}
