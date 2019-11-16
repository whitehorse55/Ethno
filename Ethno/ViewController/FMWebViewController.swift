//
//  FMWebViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/11.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import WebKit

class FMWebViewController: UIViewController , WKNavigationDelegate{

    var url : String!
    var webView : WKWebView!
    
    @IBOutlet weak var customview : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        showwebview()
        // Do any additional setup after loading the view.
    }
    
    
    private func showwebview()
    {
       webView = WKWebView(frame: self.customview.bounds, configuration: WKWebViewConfiguration())
       webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       self.webView.navigationDelegate = self
       self.customview.addSubview(webView)
       let myURL = URL(string: url)
       
       let myRequest = URLRequest(url: myURL!)
       webView.allowsBackForwardNavigationGestures = true
       webView.load(myRequest)
   }
}

