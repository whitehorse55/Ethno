//
//  Model_Weather.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/12.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation


struct CurrentLocalWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let id: Int
    let name: String
}

struct Clouds: Codable {
    let all: Int?
}

struct Coord: Codable {
    let lat: Double?
    let lon: Double?
}

struct Main: Codable {
    let humidity: Int?
    let pressure: Int?
    let temp: Double?
    let tempMax: Double?
    let tempMin: Double?
    private enum CodingKeys: String, CodingKey {
        case humidity, pressure, temp, tempMax = "temp_max", tempMin = "temp_min"
    }
}

struct Sys: Codable {
    let country: String?
    let id: Int?
    let sunrise: UInt64?
    let sunset: UInt64?
    let type: Int?
}

struct Weather: Codable {
    let description: String?
    let icon: String?
    let id: Int?
    let main: String?
}

struct Wind: Codable {
    let deg: Int?
    let speed: Double?
}
