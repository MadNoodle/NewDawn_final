///**
/**
NewDawn
Created by: Mathieu Janneau on 10/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import MessageUI
class MailPresenterViewController: UIViewController, MFMailComposeViewControllerDelegate {
  
let mailComposerVC = MFMailComposeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
    }

  override func viewWillAppear(_ animated: Bool) {
    // instatiate mailComposer
    let mailComposeViewController = configuredMailComposeViewController()

    // check if device can send mail ( CARE WTIH SIMULATOR BUG)
    if MFMailComposeViewController.canSendMail() {
      
      // Customize the nav bar (FIXING MFMAILCOMPOSERVIEWCONTROLLER BUG)
      mailComposeViewController.modalPresentationStyle = .overCurrentContext
      mailComposeViewController.navigationBar.tintColor = .blue
      
      /// This is done because UIPresentationController Family cannot be instantiated from UITabBar.
      /// So we have to switch root viewController and instantiate UIViewController to contain
      /// theMF MailComposer
      // Immediately dismiss to present the MFMailComposer
      self.dismiss(animated: true, completion: nil)
      present(mailComposeViewController, animated: true)
      
    } else {
      print("error this device cannot send mail")
    }
  }
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    // set delegate to allow us to dismiss the controller
    mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    
    // Populate the mail
    mailComposerVC.setToRecipients([LocalisationString.messageRecipient])
    mailComposerVC.setSubject(LocalisationString.messageSubject)
    mailComposerVC.setMessageBody(LocalisationString.messageBody, isHTML: false)
    
    do {
      // Attachment directory path
      let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("\(LocalisationString.attachmentName).\(LocalisationString.attachmentFormat)"))
      // Convert to data
      let fileData = try Data(contentsOf: dst)
      // attach
      mailComposerVC.addAttachmentData(fileData, mimeType: LocalisationString.mime , fileName: LocalisationString.attachmentName)
    } catch let error {
      print(error)
    }
    return mailComposerVC
  }
  
  // MARK: MFMailComposeViewControllerDelegate Method
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    let tabVc = MainTabBarController()
    // load the challengeVc directly
    tabVc.selectedIndex = 1
    dismiss(animated: false, completion: nil)
    // re swap the rootViewController to jump on the main hierarchy
    UIApplication.shared.delegate?.window??.rootViewController = tabVc
    }
  }
    


