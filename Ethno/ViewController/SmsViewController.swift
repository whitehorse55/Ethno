//
//  SmsViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/10.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import MessageUI
class SmsViewController : UIViewController, MFMessageComposeViewControllerDelegate  {
    

    @IBOutlet weak var txtViewSms: UITextField!
    @IBOutlet weak var btn_Sms: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Sms.layer.cornerRadius = 6
        btn_Sms.layer.borderWidth = 2
        btn_Sms.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        txtViewSms.layer.borderWidth = 1
        txtViewSms.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        setnavigationbuttons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSms(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = self.txtViewSms.text
            controller.recipients = ["9169006070"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
         self.dismiss(animated: true, completion: nil)
     }

}


extension SmsViewController{
    private func setnavigationbuttons()
       {
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController!.navigationBar.shadowImage = UIImage()
            self.navigationController!.navigationBar.isTranslucent = true
            
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
