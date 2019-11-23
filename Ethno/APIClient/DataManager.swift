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

