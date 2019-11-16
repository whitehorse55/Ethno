//
//  EthnoViewController.swift
//  Ethno
//
//  Created by Lebron on 1/5/18.
//  Copyright © 2018 Ethno. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import AVKit

class EthnoViewController: UIViewController, AVAudioPlayerDelegate , WKNavigationDelegate {
    var webView: WKWebView!
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    var isplaying : Bool!
    
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var content_video: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isplaying = true
        btn_play.setImage(UIImage(named: "pause"), for: .normal)
        
        preparePlayer()
        showwebview()
    }
    
    @IBAction func onclickplaybutton(_ sender: Any) {
        
        if(isplaying){
            self.avPlayer?.pause()
            btn_play.setImage(UIImage(named: "play"), for: .normal)
            self.isplaying = false
        }else{
            self.avPlayer?.play()
            btn_play.setImage(UIImage(named: "pause"), for: .normal)
            self.isplaying = true
        }
    }
    
    func preparePlayer() {
    //        let urlstring = "http://www.noiseaddicts.com/samples_1w72b820/2514.mp3"
        let urlstring = "http://ethno.fm:8500/ethnofm.mp3"
//        let urlstring = "http://listen.openstream.co/3162/audio"
        let url = NSURL(string: urlstring)
        print("playing \(String(describing: url))")
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.volume = 1.0
        avPlayer?.play()
    }
    


    
    private func showwebview()
    {
        webView = WKWebView(frame: self.content_video.bounds, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.navigationDelegate = self
        self.content_video.addSubview(webView)
        let myURL = URL(string: "http://209.222.98.195:82/stream.html")
        
        let myRequest = URLRequest(url: myURL!)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(myRequest)
    }
    
    @IBAction func onclicksmsbutton(_ sender: Any) {
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let smsvc : SmsViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Sms") as! SmsViewController
        self.navigationController?.pushViewController(smsvc, animated: true)
    }
    
    @IBAction func onclickcallair(_ sender: Any) {
        if let url = URL(string: "tel://9165007877"), UIApplication.shared.canOpenURL(url) {
             if #available(iOS 10, *) {
                 UIApplication.shared.open(url)
             } else {
                 UIApplication.shared.openURL(url)
             }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
