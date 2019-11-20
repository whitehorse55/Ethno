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

class MainViewController: ViewController {
    var backimgs = ["slider","slider1","slider2","slider3"]
    
    var webView: WKWebView!
    var avPlayer:AVPlayer = AVPlayer()
    var avPlayerItem:AVPlayerItem?
    var isplaying : Bool!
    var timer = Timer()
    
    @IBOutlet weak var view_player: UIView!
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var tbl_anomunce: UITableView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var slider_volume: UISlider!
    @IBOutlet weak var clocklabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
   
    var array_announcement  = [Model_Announcements]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isplaying = true
        
        delegate.preparePlayer()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    
        setnavigationbuttons()
        showwebview()
        inittableview()
        
        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (data) in
                self.clocklabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            })
        } else {
            // Fallback on earlier versions
        }
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
    
    @IBAction func onclickalarmbutton(_ sender: Any) {
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let alarmvc : AlarmViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Alarm") as! AlarmViewController
        let nav_vc = UINavigationController(rootViewController: alarmvc)
        sideMenuController?.embed(centerViewController: nav_vc)
    }
    
    @IBAction func valuechangedslider(_ sender: Any) {
        avPlayer.volume = slider_volume.value
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

    
    @IBAction func onclickplaybutton(_ sender: Any) {
           if(isplaying){
            delegate.avPlayer.pause()
               self.isplaying = false
              btn_play.setImage(UIImage(named: "play"), for: .normal)
           }else{
            delegate.avPlayer.play()
               self.isplaying = true
               btn_play.setImage(UIImage(named: "pause"), for: .normal)
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














