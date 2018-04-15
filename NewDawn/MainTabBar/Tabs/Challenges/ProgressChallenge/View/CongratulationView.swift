///**
/**
NewDawn
Created by: Mathieu Janneau on 07/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace


import UIKit


class Congratulation: NSObject {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  

  
  // ///////////// //
  // MARK: - VIEWS //
  // ///////////// //
  
  let blackView = UIView()
  
  let container : UIView = {
    let stack = UIView()
    stack.backgroundColor = .white
    return stack
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "CONGRATULATIONS !"
    label.font = UIFont(name: UIConfig.lightFont, size: 24)
    label.textAlignment = .center
    return label
  }()
  
  let subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "You did it"
    label.font = UIFont(name: UIConfig.lightFont, size: 18)
    label.textAlignment = .center
    return label
  }()
  
  let reward: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "thumbsUp")
    return imageView
  }()
  
  
  
  // /////////////// //
  // MARK: - METHODS //
  // /////////////// //
  
  
  func showSettings() {
    //show menu
    if let window = UIApplication.shared.keyWindow {
      // Add views
      instantiateViews(window)
      blackView.frame = window.frame
      blackView.alpha = 0
      self.container.alpha = 0
      
      // animate to show the Picker
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
        self.blackView.alpha = 1
        self.container.alpha = 1
      }, completion: nil)
    }
    
    
  }
  
  func instantiateViews(_ window: UIWindow){
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    
    window.addSubview(blackView)
    window.addSubview(container)
    window.addSubview(titleLabel)
    window.addSubview(subTitleLabel)
    window.addSubview(reward)
    
    // SETTINGS
    
    container.layer.cornerRadius = 10.0
    container.layer.masksToBounds = true
    let thumbSize: CGFloat = 150
    // FRAMES
    let newOrigin: CGPoint = CGPoint(x: window.frame.width / 6, y: window.frame.height / 3)
    container.frame = CGRect(x: window.frame.width / 6, y: window.frame.height / 3, width: window.frame.width / 1.5, height: window.frame.height / 2.5)
    titleLabel.frame = CGRect(x: newOrigin.x, y: newOrigin.y + 16.0, width: self.container.frame.width, height:30)
    subTitleLabel.frame = CGRect(x: newOrigin.x, y: newOrigin.y + 54.0, width: self.container.frame.width, height:20)
    reward.frame = CGRect(x: newOrigin.x - thumbSize / 2 + self.container.frame.width / 2, y: newOrigin.y + 95, width: thumbSize, height: thumbSize)
  }
 
  // ///////////////// //
  // MARK: - SELECTORS //
  // ///////////////// //
  
 
  @objc func handleDismiss() {
    print("boom")
    UIView.animate(withDuration: 0.5) {
      self.blackView.alpha = 0
      self.container.alpha = 0
      self.container.removeFromSuperview()
      self.titleLabel.removeFromSuperview()
      self.subTitleLabel.removeFromSuperview()
      self.reward.removeFromSuperview()
      
    }
  }

  
  // //////////// //
  // MARK: - INIT //
  // //////////// //
  
  override init() {
    super.init()
    
  }
}

