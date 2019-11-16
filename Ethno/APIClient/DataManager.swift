//
//  DataManager.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/12.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Realm
import RealmSwift

class DataManager {
    static let datamanger = DataManager()
    
    public  func getWeatherData(lati : String, longi : String, completion : @escaping(CurrentLocalWeather?)-> Void, errorcallback : @escaping(_ error : Error)-> Void)
   {
       
    let url = String.init(format: Urlservice.URL_WEATHERAPI, lati, longi)
       

    Alamofire.request(url, method:.get, parameters: nil, encoding:JSONEncoding.default, headers: nil).response{
        response in
        guard let data = response.data else {return}
        do {
            let decoder = JSONDecoder()
            let weahterdata = try decoder.decode(CurrentLocalWeather.self, from: data)
            completion(weahterdata)
        } catch let error {
            print(error)
            errorcallback(error)
        }
    }
   }
    
    public func getblogdata( completion : @escaping([Model_Announcements])-> Void, errorcallback : @escaping(_ error : Error)-> Void){
        let url = Urlservice.URL_BLOG
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{
            response in
            guard let data = response.data else {return}
            do {
                let decoder = JSONDecoder()
                let blogdata = try decoder.decode([Model_Announcements].self, from: data)
                completion(blogdata)
            } catch let error {
                print(error)
                errorcallback(error)
            }
        }
    }
}


extension DataManager{
    
    public func savealarmdata(alarmhour : String, alarmmin : String, status : Bool){
        let alarmmodel = Alarm()
        alarmmodel.alarm_hour = alarmhour
        alarmmodel.alarm_min = alarmmin
        alarmmodel.alarm_status = status
        
        let realm = try! Realm()
        let myalarm = realm.objects(Alarm.self).filter("alarm_hour == %@ AND alarm_min == %@", alarmhour, alarmmin).first
        
        if let myalarm = myalarm
        {
            try! realm.write {
                myalarm.alarm_status = status
            }
            
        }else{
            try! realm.write {
                realm.add(alarmmodel)
            }
        }
    }
    
    public func getalarmdata() -> Results<Alarm>{
        let realm = try! Realm()
        return realm.objects(Alarm.self).sorted(byKeyPath: "alarm_hour", ascending: false)
    }
    
    public func deletealarmdata(alarminfo : Alarm){
         let realm = try! Realm()
        try! realm.write {
            realm.delete(alarminfo)
        }
    }
}
