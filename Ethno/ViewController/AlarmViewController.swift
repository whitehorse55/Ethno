//
//  AlarmViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/10.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController{

    @IBOutlet weak var alarmtime: UILabel!
    @IBOutlet weak var alarm_switch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavigationbuttons()
        alarm_switch.isOn = false
        alarm_switch.isHidden = true
        getalarmtime()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onclickaddbutton(_ sender: Any) {
        RPicker.selectDate(title: "Select time", datePickerMode: .time, didSelectDate: { (selectedDate) in
             // TODO: Your implementation for date
            self.alarm_switch.isOn = false
            self.alarm_switch.isHidden = false
            self.alarmtime.text = selectedDate.dateString("hh:mm")
         })
    }
    
    @IBAction func onchangevalue(_ sender: Any) {
        if alarm_switch.isOn{
            UserDefaults.standard.setalarmtime(value: alarmtime.text!)
        }else{
            UserDefaults.standard.setalarmtime(value: "")
        }
    }
    
    private func getalarmtime()
    {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: UserDefaultKeys.alarmtime.rawValue)
        {
            let alarmtime = UserDefaults.standard.getalarmtime()
            
            if alarmtime != ""
           {
               self.alarmtime.text = alarmtime
               alarm_switch.isOn = true
             alarm_switch.isHidden = false
           }
        }
      
    }
}



extension AlarmViewController
{
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
