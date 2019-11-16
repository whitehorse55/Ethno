//
//  Urlservice.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/12.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation

struct  Urlservice {
   public static let URL_WEATHERAPI = "http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=ce2b71906f702dc75ee105584a8db0d5&units=metric"
   public static let URL_BLOG = "http://new.ethno.fm/wp-getpost-api.php"
}

enum weathericons : String{
    case strom
    case rain
    case sunny
    case snow
    case clouds
    case cloudy
}

