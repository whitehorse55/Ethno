//
//  SettingViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/15.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit

class SettingViewController: ViewController {

    @IBOutlet weak var switch_mic: UISwitch!
    @IBOutlet weak var segment_unit: UISegmentedControl!
    @IBOutlet weak var switch_setting: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavigationbuttons()
        // Do any additional setup after loading the view.
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        segment_unit.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segment_unit.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        setsettinginfo()
    }
    
    @IBAction func valuesgementchanged(_ sender: Any) {
        if self.segment_unit.selectedSegmentIndex == 0{
            UserDefaults.standard.settemperture(value: true)
        }else{
            UserDefaults.standard.settemperture(value: false)
        }
    }
    
    @IBAction func valusechangedswitch(_ sender: Any) {
        UserDefaults.standard.setmicon(value: self.switch_mic.isOn)
    }
    @IBAction func valuechangedpushnotification(_ sender: Any) {
        if switch_setting.isOn{
            UIApplication.shared.registerForRemoteNotifications()
        }else{
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func setsettinginfo()
    {
        let unitstatus = UserDefaults.standard.gettemperature()
        let micstatus = UserDefaults.standard.getmicon()
        
        if unitstatus == true{
            self.segment_unit.selectedSegmentIndex = 0
        }else{
            self.segment_unit.selectedSegmentIndex = 1
        }
        
        self.switch_mic.setOn(micstatus, animated: true)
    }
    
}
