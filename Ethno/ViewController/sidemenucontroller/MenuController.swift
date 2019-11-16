//
//  MenuController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/9.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import CoreLocation


class MenuController: UIViewController {

    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_location: UILabel!
    @IBOutlet weak var img_cloudy: UIImageView!
    @IBOutlet weak var lb_temperature: UILabel!
    @IBOutlet weak var btl_menu: UITableView!
    @IBOutlet weak var haderview: UIView!
    @IBOutlet weak var lb_clock: UILabel!
    var timer = Timer()
    var array_menu  = ["Home","Call Studio","Send SMS", "Open MIC", "Schedule", "Web Site", "Alarm", "Setting"]
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        img_cloudy.image = UIImage(named: "sunny")
        btl_menu.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOpensidebar), name: .opensidebar, object: nil)
        
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (data) in
                self.lb_clock.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLocation()
    }
    
    @objc func onOpensidebar()
    {
        self.btl_menu.reloadData()
        getLocation()
    }
    
}

extension MenuController :  UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_menu", for: indexPath) as! MenuTableviewCell
        cell.lb_menuitem.text = array_menu[indexPath.row]
        cell.selectionStyle = .none
        
        let micstatus = UserDefaults.standard.getmicon()
        if indexPath.row == 3
        {
            cell.lb_menuitem.isEnabled = micstatus
        }
        return cell
    
    }
}


extension MenuController
{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 50))
        let labelview = UILabel(frame: CGRect(x: 30, y: 0, width: tableView.frame.width * 0.7, height: headerview.frame.height))
        labelview.text = "MENU"
        labelview.font = UIFont.init(name: "Baufra-Bold", size: 20)
        labelview.textColor = .darkGray
        labelview.layer.addBorder(edge: .bottom, color: .darkGray, thickness: 1.0)
        headerview.addSubview(labelview)
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         changecontentview(index: indexPath.row)
    }
    
    
    private func changecontentview(index : Int){
        var nav_vc : UINavigationController!
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        switch index {
            case 0:
              let mainvc : MainViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Main") as! MainViewController
              nav_vc = UINavigationController(rootViewController: mainvc)
            break

            case 1:
                
                if let url = URL(string: "tel://9165007877"), UIApplication.shared.canOpenURL(url)
                {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
            break

            case 2:
                 let smsvc : SmsViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Sms") as! SmsViewController
                 nav_vc = UINavigationController(rootViewController: smsvc)
            break

            case 3:
                let micstatus = UserDefaults.standard.getmicon()
                if micstatus == true{
                    let openmicvc : OpenMicViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Openmic") as! OpenMicViewController
                    nav_vc = UINavigationController(rootViewController: openmicvc)
                }
                
            break

            case 4:
               let web_vc : FMWebViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Fmweb") as! FMWebViewController
                web_vc.url = "https://calendar.google.com/calendar/"
                nav_vc = UINavigationController(rootViewController: web_vc)
            break


            case 5:
                let web_vc : FMWebViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Fmweb") as! FMWebViewController
                web_vc.url = "http://ethno.fm/new-main-2/#"
                nav_vc = UINavigationController(rootViewController: web_vc)
               
            break


            case 6:
                let alarmvc : AlarmViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Alarm") as! AlarmViewController
                nav_vc = UINavigationController(rootViewController: alarmvc)
            break
            
            case 7:
                let settingvc : SettingViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Setting") as! SettingViewController
                nav_vc = UINavigationController(rootViewController: settingvc)
            break
            
            default:
            break
        }
        
        guard  let embedcontroller = nav_vc else {
            return
        }
        
        sideMenuController?.embed(centerViewController: embedcontroller)
    }
    
}

class MenuTableviewCell: UITableViewCell {
    @IBOutlet weak var lb_menuitem: UILabel!
}


extension MenuController : CLLocationManagerDelegate{
    
        private func getLocation()
        {
           self.locationManager.requestWhenInUseAuthorization()
           if CLLocationManager.locationServicesEnabled()
           {
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.startUpdatingLocation()
           }
        }

       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let lastestlocation = locations.first else {return}
           print("locaioninfo", lastestlocation)
           getweatherdata(lati: String(lastestlocation.coordinate.latitude), longi: String(lastestlocation.coordinate.longitude))
           locationManager.stopUpdatingLocation()
       }
       
       
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if status == .authorizedAlways || status == .authorizedWhenInUse{
               self.locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.startUpdatingLocation()
           }
       }

     private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
       print("Error: \(error)")
     }
}


extension MenuController {

    
    private func getweatherdata(lati : String, longi : String)
    {
        self.haderview.activityStartAnimating(activityColor: .darkGray, backgroundColor: .white)
        DataManager.datamanger.getWeatherData(lati: lati, longi: longi, completion: { (data : CurrentLocalWeather!) in
            self.haderview.activityStopAnimating()
            self.lb_date.text = self.getcurrentdate()
            self.lb_location.text = data.name
            
            if let weather = data.weather.first?.id{
                let weathericon = self.getweatherimagename(info: weather)
                self.img_cloudy.image = UIImage(named: weathericon)
            }
            
            if  let temperature = data.main.temp {
                if #available(iOS 10.0, *) {

                    let unitstatus = UserDefaults.standard.gettemperature()
                    if unitstatus == true
                    {
                        self.lb_temperature.text = self.convertTemp(temp: temperature, from: .celsius, to: .celsius)
                    }else{
                        self.lb_temperature.text = self.convertTemp(temp: temperature, from: .celsius, to: .fahrenheit)
                    }
                   
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }) { (error) in
            self.haderview.activityStopAnimating()
            print("error found", error)
        }
    }
    
    private func getweatherimagename(info : Int) -> String{
        var weatherval = "";
        switch info {
            case 200...299:
                weatherval =  weathericons.sunny.rawValue
                
            case 300...399:
                 weatherval = weathericons.strom.rawValue

            case 500...599:
                 weatherval = weathericons.rain.rawValue
                
            case 600...699:
                 weatherval = weathericons.snow.rawValue
                            
           case 800:
                 weatherval = weathericons.sunny.rawValue
                
            case 801...802:
                 weatherval = weathericons.cloudy.rawValue
                
            case 803...804:
                 weatherval = weathericons.clouds.rawValue
                
            default:
                 weatherval = ""
                break
        }
        
        return weatherval
    }
    
    private func getcurrentdate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "EEEE, MMM d"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    private func timestamptodate(unixtimeInterval : Double) -> String
    {
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    
}

extension MenuController{
    @available(iOS 10.0, *)
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
      let mf = MeasurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      mf.unitOptions = .providedUnit
      let input = Measurement(value: temp, unit: inputTempType)
      let output = input.converted(to: outputTempType)
      return mf.string(from: output)
    }
}

