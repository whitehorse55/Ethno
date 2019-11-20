//
//  ViewController.swift
//  Ethno
//
//  Created by Lebron on 1/5/18.
//  Copyright © 2018 Ethno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func setnavigationbuttons()
    {
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController!.navigationBar.shadowImage = UIImage()
            self.navigationController!.navigationBar.isTranslucent = true
            
           let barButtonItem_call = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "calltostudio") , target:  self, action:  #selector(onclickbarbuttons), tag: 0)
           let barButtonItem_sms = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "sms"), target:  self ,action:  #selector(onclickbarbuttons), tag: 1)
           let barButtonItem_mic = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "openmic"), target:  self, action:  #selector(onclickbarbuttons), tag: 2)
           
           let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
           space.width = 20.0
           
           self.navigationController?.addLogoImage(image: UIImage(named: "logo")!, navItem: self.navigationItem)
           navigationItem.rightBarButtonItems = [barButtonItem_call, space, barButtonItem_sms, space, barButtonItem_mic]
     }
    
    
       @objc func onclickbarbuttons(sender : UIButton)
       {
            
            var nav_vc : UINavigationController!
            let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            switch sender.tag {
            
            case 0:
                if let url = URL(string: "tel://9165007877"), UIApplication.shared.canOpenURL(url)
                {
                      if #available(iOS 10, *) {
                          UIApplication.shared.open(url)
                      } else {
                          UIApplication.shared.openURL(url)
                      }
                }
                break
                
            case 1:
                let smsvc : SmsViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Sms") as! SmsViewController
                nav_vc = UINavigationController(rootViewController: smsvc)
                break
                
            case 2:
                let openmicvc : OpenMicViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Openmic") as! OpenMicViewController
                nav_vc = UINavigationController(rootViewController: openmicvc)
                break
                
            default:
                break
            }
        
            guard  let embedcontroller = nav_vc else {
                       return
                   }
                   
            sideMenuController?.embed(centerViewController: embedcontroller)
       }
       
       override var prefersStatusBarHidden: Bool{
           return true
       }

}




