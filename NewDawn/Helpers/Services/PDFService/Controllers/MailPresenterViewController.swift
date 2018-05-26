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
    mailComposerVC.mailComposeDelegate = self
    
    // Populate the mail
    mailComposerVC.setToRecipients([""])
    mailComposerVC.setSubject(NSLocalizedString("NewDawn sent you an e-mail", comment: ""))
    mailComposerVC.setMessageBody(NSLocalizedString("Here is my report", comment: ""), isHTML: false)
    
    do {
      // Attachment directory path
      let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("NewDawnReport" + ".pdf"))
      // Convert to data
      let fileData = try Data(contentsOf: dst)
      // attach
      mailComposerVC.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "NewDawnReport")
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
