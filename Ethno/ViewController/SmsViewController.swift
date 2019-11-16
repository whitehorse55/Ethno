//
//  SmsViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/10.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import MessageUI
class SmsViewController : ViewController, MFMessageComposeViewControllerDelegate  {
    

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


