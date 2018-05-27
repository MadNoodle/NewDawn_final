///**
/**
 NewDawn
 Created by: Mathieu Janneau on 07/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace
import Foundation
import UIKit
import WebKit

class PDFPreviewViewController: UIViewController {
  
  var webView: WKWebView?
  var uiWebView: UIWebView?
  /// File to preview url path
  var url: URL!
  override func viewDidLoad() {
    super.viewDidLoad()
    // load url file
    let req = NSMutableURLRequest(url: url)
    // check timeout and cache data
    req.timeoutInterval = 60.0
    req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    if #available(iOS 11.0, *){
      webView?.frame = self.view.frame
      view.addSubview(webView!)
      webView?.load(req as URLRequest)
      
    } else {
      uiWebView?.frame = self.view.frame
      view.addSubview(uiWebView!)
      uiWebView?.loadRequest(req as URLRequest)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc @IBAction fileprivate func close(_ sender: AnyObject!) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func share(_ sender: UIButton) {
    // MFMailComposer container
    let mailCompVc = MailPresenterViewController()
    // switch hierarchy to present a MFMailComposer
    UIApplication.shared.delegate?.window??.rootViewController = mailCompVc
    
  }
  
  func setupWithURL(_ url: URL) {
    self.url = url
  }
  
}
