//
//  AlarmViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/10.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmViewController: ViewController{

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
            UserDefaults.standard.setalarmstatus(value: true)
            let alarmhours = getsubstring(str: self.alarmtime.text!)
            
            if #available(iOS 10.0, *) {
                setalarmconfig(alarmhour: Int(alarmhours[0])! , alarmmin: Int(alarmhours[1])!)
            } else {
                // Fallback on earlier versions
            }
        }else{
            UserDefaults.standard.setalarmtime(value: "")
            UserDefaults.standard.setalarmstatus(value: false)
        }
    }
    
    private func getalarmtime()
    {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: UserDefaultKeys.alarmtime.rawValue)
        {
            let alarmtime = UserDefaults.standard.getalarmtime()
            let alarmstatus = UserDefaults.standard.gettemperature()
            self.alarmtime.text = alarmtime
            alarm_switch.isOn = alarmstatus
            alarm_switch.isHidden = false
            
            let alarmhours = getsubstring(str: alarmtime)
            
            if #available(iOS 10.0, *) {
                setalarmconfig(alarmhour: Int(alarmhours[0])! , alarmmin: Int(alarmhours[1])!)
            } else {
                // Fallback on earlier versions
            }
        }
      
    }
    
    private func getsubstring(str : String) -> [String]
    {
        let sub_strs = str.components(separatedBy: ":")
        return sub_strs
    }
}






@available(iOS 10.0, *)
extension AlarmViewController{
    private func setalarmconfig(alarmhour : Int, alarmmin : Int){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Welcome back to Ethno"
                content.body = ""
                content.categoryIdentifier = "alarm"
                content.userInfo = ["userinfo": "alarm"]
                content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init("alarm.mp3"))

               var dateComponents = DateComponents()
               dateComponents.hour = alarmhour
               dateComponents.minute = alarmmin
               let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
               center.add(request)
            } else {
                self.showToast(message: "LocalNotification not guranted", font: UIFont(name: "Baufra-Bold", size: 16.0)!)
            }
        }
    }
}
