//
//  WeatherAPI.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/14.
//  Copyright © 2019 Peking University. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

func loadTestData<T: Decodable>(filename: String, as type: T.Type = T.self) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("can't find \(filename)")
    }
    
    guard let data = try? Data(contentsOf: file) else {
        fatalError("can't open \(filename)")
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.getCustomStrategy()
        return try decoder.decode(T.self, from: data)
    } catch(let error){
        fatalError("\(error) can't parse \(filename)")
    }
}

class WeatherAPI {
    private let session = URLSession.shared
    
    private let key: String
    private let lang: String
    private let unit: String
    
    public private(set) var weather: Weather!
    
    private struct WeatherJSONRoot: Codable {
        let root: [Weather]
        enum CodingKeys: String, CodingKey {
            case root = "HeWeather6"
        }
    }
    
    init(unit: String, lang: String) {
        self.key = APIKeyManager.shared.key
        self.lang = lang
        self.unit = unit
        self.weather = loadTestData(filename: "weatherData.json", as: WeatherJSONRoot.self).root[0]
    }
    
    func updateWeather() {
        updateCity(of: weather.basic.cityID)
    }
    
    func updateCity(of cityID: String) {
        guard var weatherAPIURL = URLComponents(string: APIKeyManager.shared.weatherUrl) else {
            fatalError("error: bad weatherAPIURL")
        }
        
        weatherAPIURL.queryItems = [
            URLQueryItem(name: "location", value: cityID),
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "unit", value: unit)]
        guard let weatherAPIURLWithQuery = weatherAPIURL.url else {
            fatalError("error: bad query")
        }
        
        print(weatherAPIURLWithQuery)
        session.dataTask(with: weatherAPIURLWithQuery) { result in
            switch result {
            case .failure:
                print("failed: get json")
            case .success(let data, _):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.getCustomStrategy()
                
                let data = try! decoder.decode(WeatherJSONRoot.self, from: data).root[0]
                if data.status == "ok" {
                    self.weather = data
                    print("weather updated")
                } else {
                    print("error: update weather \(data.status)")
                }
                
            }
        }.resume()
    }
    
}

struct Weather: Codable {
    let basic: Basic // 基础信息，包括所查询的城市/地区的一些基本信息，例如名称、ID、经纬度等
    let update: Update // 接口更新时间，包括城市/地区所在地的当地时间和UTC时间，即使其中有个别数据没有变化，update时间也会变更。
    let status: String // 接口状态,状态码及错误码
    let now: Now // 实况天气即为当前时间点的天气状况以及温湿风压等气象指数
    let dailyForecast: [DailyForecast] // 3-10天天气预报数据
    let hourly: [Hourly] // 未来24-168个小时，逐小时的天气预报数据数据
    let lifestyle: [LifeStyle]? // 生活指数和生活指数预报
    let lifestyleForecast: [LifeStyleForecast]? // 生活指数预报提供最长未来3天的预报数据
    
    enum CodingKeys: String, CodingKey {
        case basic
        case update
        case status
        case now
        case dailyForecast = "daily_forecast"
        case hourly
        case lifestyle
        case lifestyleForecast = "lifestyle_forecast"
    }
}

struct Basic: Codable, Identifiable, Hashable {
    var id: String { cityID }
    let location: String // 地区／城市名称 卓资
    let cityID: String // 地区／城市ID CN101080402
    let latitude: String // 地区／城市纬度 40.89576
    let longitude: String // 地区／城市经度
    let parentCity: String // 该地区／城市的上级城市 乌兰察布
    let adminArea: String // 该地区／城市所属行政区域 内蒙古
    let country: String // 该地区／城市所属国家名称 中国
    let timezone: String // 该地区／城市所在时区 +8.0
    
    enum CodingKeys: String, CodingKey {
        case location
        case cityID = "cid"
        case latitude = "lat"
        case longitude = "lon"
        case parentCity = "parent_city"
        case adminArea = "admin_area"
        case country = "cnty"
        case timezone = "tz"
    }
}

struct Update: Codable {
    var localTime: Date // 当地时间，24小时制，格式yyyy-MM-dd HH:mm
    let utcTime: Date // UTC时间，24小时制，格式yyyy-MM-dd HH:mm
    
    enum CodingKeys: String, CodingKey {
        case localTime = "loc"
        case utcTime = "utc"
    }
}

struct Now: Codable {
    let feelsLike: String // 体感温度，默认单位：摄氏度 23
    let temperature: String// 温度，默认单位：摄氏度 21
    let condCode: String // 实况天气状况代码 100
    let condText: String // 实况天气状况描述 晴
    let windDegree: String // 风向360角度 305
    let windDirection: String // 风向 西北
    let windScaleClass: String // 风力 3-4
    let windSpeed: String // 风速，公里/小时 15
    let humidity: String // 相对湿度 40
    let precipitation: String // 降水量 0
    let pressure: String // 大气压强 1020
    let visibility: String // 能见度，默认单位：公里 10
    let cloud: String // 云量 23
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "fl"
        case temperature = "tmp"
        case condCode = "cond_code"
        case condText = "cond_txt"
        case windDegree = "wind_deg"
        case windDirection = "wind_dir"
        case windScaleClass = "wind_sc"
        case windSpeed = "wind_spd"
        case humidity = "hum"
        case precipitation = "pcpn"
        case pressure = "pres"
        case visibility = "vis"
        case cloud
    }
}

struct DailyForecast: Codable, Identifiable {
    var id: String { date.toString() }
    let date: Date // 预报日期 2013-12-30
    let sunRise: Date // 日出时间 07:36
    let sunSink: Date // 日落时间 16:58
    let moonRise: Date? // 月升时间
    let moonSink: Date? // 月落时间
    let temperatureMax: String // 最高温度 4
    let temperatureMin: String // 最低温度 -5
    let conditionCodeDay: String // 白天天气状况代码 100
    let conditionCodeNight: String // 夜晚天气状况代码 100
    let conditionTextDay: String // 白天天气状况描述
    let conditionTextNight: String // 夜晚天气状况描述
    let windDegree: String // 风向360角度 305
    let windDirection: String // 风向 西北
    let windScaleClass: String // 风力 3-4
    let windSpeed: String // 风速，公里/小时 15
    let humidity: String // 相对湿度 40
    let precipitation: String // 降水量 0
    let precipitationProbability: String // 降水概率，百分比
    let pressure: String // 大气压强 1020
    let uvIndex: String// 紫外线强度指数 3
    let visibility: String // 能见度，默认单位：公里 10
    
    enum CodingKeys: String, CodingKey {
        case date
        case sunRise = "sr"
        case sunSink = "ss"
        case moonRise = "mr"
        case moonSink = "ms"
        case temperatureMax = "tmp_max"
        case temperatureMin = "tmp_min"
        case conditionCodeDay = "cond_code_d"
        case conditionCodeNight = "cond_code_n"
        case conditionTextDay = "cond_txt_d"
        case conditionTextNight = "cond_txt_n"
        case windDegree = "wind_deg"
        case windDirection = "wind_dir"
        case windScaleClass = "wind_sc"
        case windSpeed = "wind_spd"
        case humidity = "hum"
        case precipitation = "pcpn"
        case precipitationProbability = "pop"
        case pressure = "pres"
        case uvIndex = "uv_index"
        case visibility = "vis"
    }
}

struct Hourly: Codable, Identifiable {
    var id: String { time.toString() }
    let time: Date // 预报时间，格式yyyy-MM-dd hh:mm
    let temperature: String// 温度，默认单位：摄氏度 21
    let condCode: String // 实况天气状况代码 100
    let condText: String // 实况天气状况描述 晴
    let windDegree: String // 风向360角度 305
    let windDirection: String // 风向 西北
    let windScaleClass: String // 风力 3-4
    let windSpeed: String // 风速，公里/小时 15
    let humidity: String // 相对湿度 40
    let pressure: String // 大气压强 1020
    let precipitationProbability: String // 降水概率，百分比
    let dewPoint: String // 露点温度
    let cloud: String // 云量 23
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "tmp"
        case condCode = "cond_code"
        case condText = "cond_txt"
        case windDegree = "wind_deg"
        case windDirection = "wind_dir"
        case windScaleClass = "wind_sc"
        case windSpeed = "wind_spd"
        case humidity = "hum"
        case pressure = "pres"
        case precipitationProbability = "pop"
        case dewPoint = "dew"
        case cloud
    }
}

struct LifeStyle: Codable {
    let brief: String // 生活指数简介
    let text: String // 生活指数详细描述
    let type: LifeStyleType
    
    enum CodingKeys: String, CodingKey {
        case brief = "brf"
        case text = "txt"
        case type
    }
}

struct LifeStyleForecast: Codable {
    let date: Date // 预报日期，例如2017-12-30
    let brief: String // 生活指数简介
    let text: String // 生活指数详细描述
    let type: LifeStyleType
    
    enum CodingKeys: String, CodingKey {
        case date
        case brief = "brf"
        case text = "txt"
        case type
    }
}

enum LifeStyleType: String, Codable {
    case comf // 舒适度指数
    case cw // 洗车指数
    case drsg // 穿衣指数
    case flu // 感冒指数
    case sport // 运动指数
    case trav // 旅游指数
    case uv // 紫外线指数
    case air // 空气污染扩散条件指数
    case ac // 空调开启指数
    case ag // 过敏指数
    case gl // 太阳镜指数
    case mu // 化妆指数
    case airc // 晾晒指数
    case ptfc // 交通指数
    case fsh // 钓鱼指数
    case spi // 防晒指数
}

enum StatusCode {
    case ok
    case invalidKey
    case invalidKeyType
    case invalidParam
    case badBind
    case noDataForThisLocation
    case noMoreRequests
    case noBalance
    case tooFast
    case dead
    case unknownLocation
    case permissionDenied
    case signError
}
