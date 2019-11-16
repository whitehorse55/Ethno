//
//  MainViewController.swift
//  Ethno
//
//  Created by Lebron on 1/5/18.
//  Copyright © 2018 Ethno. All rights reserved.
//

import UIKit
import CoreLocation
import HSCycleGalleryView
import WebKit
import AVFoundation
import AVKit

class MainViewController: UIViewController {
    var backimgs = ["slider","slider1","slider2","slider3"]
    
    var webView: WKWebView!
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    var isplaying : Bool!
    
    @IBOutlet weak var view_player: UIView!
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var tbl_anomunce: UITableView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var array_announcement  = [Model_Announcements]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isplaying = true
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        setnavigationbuttons()
        preparePlayer()
        showwebview()
        inittableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setpagerview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
 
}

extension MainViewController : HSCycleGalleryViewDelegate{
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int {
        return backimgs.count
    }
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
         let cell = cycleGalleryView.dequeueReusableCell(withIdentifier: "cell_advertise", for: IndexPath(item: index, section: 0)) as! Cell_Advertise
        cell.backgroundimage.image = UIImage(named: backimgs[index])
        print("indexinof", index)
        return cell
    }
    
    private func setpagerview(){
        let pager = HSCycleGalleryView(frame: CGRect(x: 0, y: 10
            , width: UIScreen.main.bounds.width, height: 250))
        pager.register(cellClass: Cell_Advertise.self, forCellReuseIdentifier: "cell_advertise")
        pager.delegate = self
        self.scrollview.addSubview(pager)
        pager.reloadData()
    }
}


extension MainViewController{
    private func setnavigationbuttons()
    {
        let barButtonItem_call = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "calltostudio") , target:  self, action:  #selector(onclickbarbuttons))
        let barButtonItem_sms = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "sms"), target:  self ,action:  #selector(onclickbarbuttons))
        let barButtonItem_mic = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "openmic"), target:  self, action:  #selector(onclickbarbuttons))
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20.0
        
        self.navigationController?.addLogoImage(image: UIImage(named: "logo")!, navItem: self.navigationItem)
        navigationItem.rightBarButtonItems = [barButtonItem_call, space, barButtonItem_sms, space, barButtonItem_mic]
    }
    
    @objc func onclickbarbuttons(sender : UIButton)
    {
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}


extension MainViewController :  AVAudioPlayerDelegate , WKNavigationDelegate{
   
    private func showwebview()
    {
       webView = WKWebView(frame: self.videoview.bounds, configuration: WKWebViewConfiguration())
       webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       self.webView.navigationDelegate = self
       self.videoview.addSubview(webView)
       let myURL = URL(string: "http://209.222.98.195:82/stream.html")
       let myRequest = URLRequest(url: myURL!)
       webView.allowsBackForwardNavigationGestures = true
       webView.load(myRequest)
    }
    
     func preparePlayer() {
            let urlstring = "http://ethno.fm:8500/ethnofm.mp3"
            let url = NSURL(string: urlstring)
            avPlayerItem = AVPlayerItem.init(url: url! as URL)
            avPlayer = AVPlayer.init(playerItem: avPlayerItem)
            avPlayer?.volume = 1.0
            avPlayer?.play()
    }
    
    @IBAction func onclickplaybutton(_ sender: Any) {
           if(isplaying){
               self.avPlayer?.pause()
               self.isplaying = false
           }else{
               self.avPlayer?.play()
               self.isplaying = true
           }
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func inittableview()
    {
        self.tbl_anomunce.register(UINib(nibName: "Cell_Announcement", bundle: nil), forCellReuseIdentifier: "cell_announce" )
        self.tbl_anomunce.separatorStyle = .none
        generatetedata()
    }
    
    private func generatetedata(){
        DataManager.datamanger.getblogdata(completion: { (data) in
            self.array_announcement = data
            self.tbl_anomunce.reloadData()
        }) { (error) in
            self.showToast(message: "Data not existed", font: UIFont(name: "system", size: 16)!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_announcement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  : Cell_Announcement = tableView.dequeueReusableCell(withIdentifier: "cell_announce", for: indexPath) as! Cell_Announcement
        let model  = array_announcement[indexPath.row]
        cell.img_announce.downloaded(from: model.image, contentMode: .scaleAspectFill)
        cell.lb_title.text = model.title
        cell.lb_description.text = model.content
        cell.selectionStyle = .none
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model  = array_announcement[indexPath.row]
        gotowebpage(urlinfo: model.link)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    private func gotowebpage(urlinfo : String){
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let web_vc : FMWebViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Fmweb") as! FMWebViewController
        web_vc.url = urlinfo
        self.navigationController?.pushViewController(web_vc, animated: true)
    }
}













