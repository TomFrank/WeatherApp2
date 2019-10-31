//
//  AirAPI.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/14.
//  Copyright © 2019 Peking University. All rights reserved.
//

import Foundation

class AirAPI {
    public private(set) var air: Air!
    private let session = URLSession.shared
    
    private let key: String
    let lang: String
    let unit: String
    
    private struct WeatherJSONRoot: Codable {
        let root: [Air]
        enum CodingKeys: String, CodingKey {
            case root = "HeWeather6"
        }
    }
    
    init(unit: String, lang: String) {
        self.key = APIKeyManager.shared.key
        self.lang = lang
        self.unit = unit
        air = loadTestData(filename: "airData.json", as: WeatherJSONRoot.self).root[0]
    }
    
    func updateCity(of cityID: String) {
        guard var airAPIURL = URLComponents(string: APIKeyManager.shared.airUrl) else {
            fatalError("error: bad weatherAPIURL")
        }
        airAPIURL.queryItems = [
            URLQueryItem(name: "location", value: cityID),
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "unit", value: unit)]
        guard let airAPIURLWithQuery = airAPIURL.url else {
            fatalError("error: bad query")
        }
        
        session.dataTask(with: airAPIURLWithQuery) { result in
            switch result {
            case .failure:
                print("failed: get json")
            case .success(let data, _):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.getCustomStrategy()

                let data = try! decoder.decode(WeatherJSONRoot.self, from: data).root[0]
                if data.status == "ok" {
                    self.air = data
                } else {
                    print("error: update air \(data.status)")
                }
            }
        }.resume()
    }
    
    func updateAir() {
        updateCity(of: air.basic.cityID)
    }
}

struct Air: Codable {
    let basic: Basic
    let update: Update
    let status: String
    let airNowCity: AirNowCity
    let airNowStation: [AirNowStation]
    let airForecast: [AirForecast]?
    
    enum CodingKeys: String, CodingKey {
        case basic
        case update
        case status
        case airNowCity = "air_now_city"
        case airNowStation = "air_now_station"
        case airForecast = "air_forecast"
    }
}

struct AirNowCity: Codable {
    let publishTime: Date
    let aqi: String
    let main: String // 主要污染物
    let quality: String // 空气质量 取值范围:优，良，轻度污染，中度污染，重度污染，严重污染
    let pm10: String
    let pm25: String
    let no2: String
    let so2: String
    let co: String
    let o3: String
    
    enum CodingKeys: String, CodingKey {
        case publishTime = "pub_time"
        case aqi
        case main
        case quality = "qlty"
        case pm10
        case pm25
        case no2
        case so2
        case co
        case o3
    }
}

struct AirNowStation: Codable {
    let publishTime: Date
    let airStation: String
    let latitude: String
    let longitude: String
    let aqi: String
    let main: String
    let quality: String
    let pm10: String
    let pm25: String
    let no2: String
    let so2: String
    let co: String
    let o3: String
    
    enum CodingKeys: String, CodingKey {
        case publishTime = "pub_time"
        case airStation = "air_sta"
        case latitude = "lat"
        case longitude = "lon"
        case aqi
        case main
        case quality = "qlty"
        case pm10
        case pm25
        case no2
        case so2
        case co
        case o3
    }
}

struct AirForecast: Codable {
    let date: Date
    let aqi: String
    let main: String
    let quality: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case aqi
        case main
        case quality = "qlty"
    }
}
