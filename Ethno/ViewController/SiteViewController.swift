//
//  SiteViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/4.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import WebKit

class SiteViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showwebview()
        // Do any additional setup after loading the view.
    }
    

       private func showwebview()
       {
           webView = WKWebView(frame: self.view.bounds, configuration: WKWebViewConfiguration())
           webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.webView.navigationDelegate = self
           self.view = webView
           let myURL = URL(string: "http://ethno.fm/")
           
           let myRequest = URLRequest(url: myURL!)
           webView.allowsBackForwardNavigationGestures = true
           webView.load(myRequest)
       }
    
    override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.navigationBar.isHidden = false
      }

}
