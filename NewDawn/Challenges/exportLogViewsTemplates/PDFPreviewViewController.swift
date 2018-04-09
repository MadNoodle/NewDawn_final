///**
/**
 NewDawn
 Created by: Mathieu Janneau on 07/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace
import Foundation
import UIKit
import MessageUI
import WebKit

class PDFPreviewViewController: UIViewController, MFMailComposeViewControllerDelegate {
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  @IBOutlet weak var webView: WKWebView!
  var url: URL!
  override func viewDidLoad() {
    super.viewDidLoad()
    let req = NSMutableURLRequest(url: url)
    req.timeoutInterval = 60.0
    req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    webView.load(req as URLRequest)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc @IBAction fileprivate func close(_ sender: AnyObject!) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func share(_ sender: UIButton) {
   
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      mailComposeViewController.modalPresentationStyle = .overCurrentContext
      mailComposeViewController.navigationBar.tintColor = .blue
      UIApplication.shared.keyWindow?.rootViewController?.present(mailComposeViewController, animated: false, completion: nil)
     
    } else {
     
    }
  }
  
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
   // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    
    mailComposerVC.setToRecipients(["mjanneau@gmail.com"])
    mailComposerVC.setSubject("Sending you an in-app e-mail...")
    mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
    
    return mailComposerVC
  }
  
  // MARK: MFMailComposeViewControllerDelegate Method

  public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
  }
  
  func setupWithURL(_ url: URL) {
    self.url = url
  }
  
}





